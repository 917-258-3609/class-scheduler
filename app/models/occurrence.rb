class Occurrence < ApplicationRecord
    # TODO: Merge occurrence counting together
    Duration = ActiveSupport::Duration

    belongs_to :schedule, optional: true
    
    validates :duration, presence: true, comparison: {other_than: 0}
    validates :period, allow_nil: true, comparison: {other_than: 0}
    validate :duration_is_shorter_than_period
    validate :recurring_occurrences_are_disjoint

    def one_time?
        return self.period.nil?
    end
    def inf_recur?
        return self.count.nil?
    end
    def occurs_on?(time)
        return false if !self.inf_recur? && time > self.end_time
        return false if time < self.start_time
        time_diff = time - self.start_time
        period = if self.one_time? 
                 then time_diff
                 else Time.at(time_diff.to_i % self.period.to_i)
                 end
        return time_diff <= self.duration
    end
    def occurring?
        return self.occurs_on?(Time.now)
    end
    def occurred_count(time=Time.now)
        return 0 if time < self.start_time
        return 1 if self.one_time?
        return self.count if !self.end_time.nil? && time > self.end_time
        return ((time - self.start_time) / self.period).floor + 1
    end
    def next_occurring_time(time=Time.now)
        return self.start_time if time < self.start_time
        return time if self.occurs_on?(time)
        return nil if self.occurred_count(time) == self.count
        period_cnt = ((time - self.start_time)/(self.period)).ceil
        return self.start_time + period_cnt*self.period
    end
    def end_time
        return nil if self.inf_recur?
        recur_duration = self.one_time? ? 0 : self.period * self.count
        return self.start_time + recur_duration + self.duration
    end
    def overlapping?(o)
        # TODO: throw error here instead
        # assert(self.one_time? || self.period == 1.week)
        # assert(o.one_time? || o.period == 1.week)
        # assert(self.duration < 1.day && o.duration < 1.day)
        # puts(self.start_time)
        # puts(self.end_time)
        # puts(o.start_time)
        # puts(o.end_time)
        return false if !self.inf_recur? && !o.inf_recur? &&
                        (self.start_time > o.end_time || 
                        o.start_time > self.end_time)
        s_period_time = Time.at(self.start_time.to_i % 1.week.to_i) 
        o_period_time = Time.at(o.start_time.to_i % 1.week.to_i)

        start_diff = s_period_time - o_period_time
        return o.duration > start_diff && start_diff > (-self.duration)
    end
    private
    def duration_is_shorter_than_period
        return true if self.one_time?
        errors.add(:occurrence, "Duration must be smaller than period") if self.duration >= self.period
    end
    # one_time_occurrence should have nil period
    def one_time_occurrence
        return true unless self.one_time?
        errors.add(:occurrence, "One time event must have 1 count") if self.count.nil? || self.count != 1
    end
    def recurring_occurrences_are_disjoint
        return true if self.one_time? || self.schedule.nil?
        other_occurrences = self.schedule.occurrences.filter{|o|o.id != self.id}
        if other_occurrences.any?{|o|o.overlapping?(self)}
            errors.add(:occurrence, "Occurrences must be disjoint")
        end 
    end
end
