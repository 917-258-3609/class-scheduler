require "./app/helpers/occurrences_helper"
class Occurrence < ApplicationRecord
    include OccurrencesHelper
    # TODO: Merge occurrence counting together
    Duration = ActiveSupport::Duration

    # Association
    belongs_to :schedule, optional: true
    
    # Validation
    validates :duration, presence: true, comparison: {other_than: 0}
    validates :period, allow_nil: true, comparison: {other_than: 0}
    validate :duration_is_shorter_than_period
    validate :one_time_occurrence
    validates_associated :schedule

    # Scope
    scope :generally_occurs_on, ->(time) {
        where("start_time <= ? AND (? <= end_time OR end_time IS NULL)", time, time)
    }
    
    # Callback
    before_validation(on: [:create, :update]) do
        if self.inf_recur?
            self.end_time = nil 
        else
            recur_duration = (self.period || 0) * (self.count-1)
            self.end_time = self.start_time + recur_duration + self.duration
        end
    end

    def one_time?
        return self.period.nil?
    end
    def inf_recur?
        return self.count.nil?
    end 

    def occurs_on(time)
        return nil if !self.inf_recur? && time > self.end_time
        return nil if time < self.start_time
        time_diff = time - self.start_time
        if self.one_time? 
            offset = time_diff.to_i
        else 
            offset = time_diff.to_i % self.period.to_i
        end
        return self if offset <= self.duration
    end
    def occurs_on?(time)
        return !!self.occurs_on(time)
    end
    def occurring
        return self.occurs_on(Time.now)
    end
    def occurring?
        return !!self.occurring
    end
    
    def occurred_count(time=Time.now)
        return 0 if time < self.start_time
        return 1 if self.one_time? || time == self.start_time
        return self.count if !self.end_time.nil? && time > self.end_time
        return ((time - self.start_time) / self.period).floor + 1
    end
    def next_occurring_time(time=Time.now)
        return self.start_time if time < self.start_time
        return time if self.occurs_on(time)
        return nil if self.occurred_count(time) == self.count
        period_cnt = ((time - self.start_time)/(self.period)).floor + 1
        return self.start_time + period_cnt*self.period
    end 

    def overlapping?(o)
        # TODO: throw error here instead
        # assert(self.one_time? || self.period == 1.week)
        # assert(o.one_time? || o.period == 1.week)
        # assert(self.duration < 1.day && o.duration < 1.day)
        
        return false if !self.inf_recur? && !o.inf_recur? &&
                        (self.start_time > o.end_time || 
                        o.start_time > self.end_time)
        s_period_time = Time.at(self.start_time.to_i % 1.week.to_i) 
        o_period_time = Time.at(o.start_time.to_i % 1.week.to_i)

        start_diff = s_period_time - o_period_time
        return o.duration > start_diff && start_diff > (-self.duration)
    end
    def calendar_occurrences_in(start_time, end_time, schedule)
        res = []
        return res if end_time < self.start_time || (!self.inf_recur? && self.end_time <= start_time)
        if self.one_time?
            res << CalendarOccurrence.new(self.start_time, self.end_time, schedule)
        else
            i = self.next_occurring_time(start_time)
            c = occurred_count(i)
            while i < end_time && c <= self.count
                res << CalendarOccurrence.new(i, i+self.duration,schedule)
                i += self.period
                c += 1
            end
        end
        return res
    end
    def build_occurrence_before(time)
        cnt = self.occurred_count(time)
        cnt -= 1 if self.occurs_on?(time)
        return nil if cnt <= 0
        return Occurrence.new(
            start_time: self.start_time,
            count: cnt,
            period: (cnt == 1 ? nil : self.period),
            duration: self.duration,
            schedule: self.schedule
        )
    end
    def build_occurrence_after(time)
        occurred_count = self.occurred_count(time)
        occurred_count -= 1 if self.occurs_on?(time)
        
        cnt = self.count && self.count - occurred_count
        return nil if cnt && cnt <= 0

        start_time = self.start_time + occurred_count * self.period
        return Occurrence.new(
            start_time: start_time,
            count: cnt,
            period: (cnt && cnt == 1 ? nil : self.period),
            duration: self.duration,
            schedule: self.schedule
        )
    end



    private
    def duration_is_shorter_than_period
        return true if self.one_time?
        errors.add(:occurrence, "Duration must be smaller than period") if self.duration > self.period
    end
    def one_time_occurrence
        return true unless self.one_time?
        errors.add(:occurrence, "One time event must have 1 count") if self.count.nil? || self.count != 1
    end
end
