class Occurrence < ApplicationRecord
    belongs_to :schedule
    has_toggled_attr(:negative)
    
    validate :duration, comparison: {not_equal_to: 0}
    validate :period, comparison: {not_equal_to: 0}
    validate :one_time_occurrence
    validate :duration_is_shorter_than_period
    validate :recurring_occurrences_are_disjoint


    def occurs_on?(time)
        period = if self.period.nil? then 1 else self.period
        offset = (time - self.start_time) % period
        return 0 <= offset && offset <= self.duration
    end
    def occurring?
        return self.occurs_on?(Time.now)
    end
    def occurred_count(time=Time.now)
        return 0 if Time.now < self.start_time
        return 1 if self.period.nil?
        return (time - self.start_time) / self.period
    end
    def next_occurring_time
        return self.start_time if Time.now < self.start_time
        return Time.now if self.occurring?
        return nil if self.occurred_count == self.count 
        return (Time.now - self.start_time).ceil(self.period) + self.start_time
    end
    def end_time
        return self.start_time + (self.period * self.count) + self.duration
    end
    def overlapping?(o)
        # TODO: throw error here instead
        assert(self.period.nil? || self.period == 1.week)
        assert(o.period.nil? || o.period == 1.week)
        assert(self.duration < 1.day && o.duration < 1.day)

        return false if self.start_time >= o.end_time || 
                        o.start_time >= self.end_time

        s_period_time = if self.period.nil? 
                        then self.start_time 
                        else self.start_time % self.period
        o_period_time = if o.period.nil? 
                        then o.start_time 
                        else o.start_time % o.period

        start_diff = s_period_time - o_period_time
        return start_diff >= o.duration || start_diff <= (-self.duration)
    end
    private
    def duration_is_shorter_than_period
        errors.add(:occurrence, "Duration must be smaller than period") if self.duration >= self.period
    end
    # one_time_occurrence should have nil period
    def one_time_occurrence
        return true unless self.period.nil?
        errors.add(:occurrence, "One time event must have 1 count") if self.count != 1
    end
    def recurring_occurrences_are_disjoint
        return true if self.period.nil?
        other_occurrences = self.schedule.occurrences.filter{|o|o.id != self.id}
        if other_occurrences.any?{|o|o.overlapping?(self)}
            errors.add(:occurrence, "Occurrences must be disjoint") 
    end
end
