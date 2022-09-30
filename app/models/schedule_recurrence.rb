class ScheduleRecurrence < ApplicationRecord
    # Associations   
    belongs_to :schedule
   
    # Validations
    validates_presence_of :start_time_from_bow 
    validates_presence_of :end_time_from_bow
    validates :start_time_from_bow, comparison: {less_than: 1.week} 
    validates :end_time_from_bow, comparison: {less_than: 1.week} 
    validate :duration_is_positive_and_less_than_one_day  
    
    # Scope
    
    def duration() = self.end_time_from_bow - self.start_time_from_bow
    
    private
    def duration_is_positive_and_less_than_one_day
        d = self.duration
        if (d < 0)
            errors.add(:schedule_recurrence, "Class start time should be before end time")
            return
        end
        if (d >= 1.day)
            errors.add(:schedule_recurrence, "Class duration cannot be equal or longer than a day")
            return
        end
        return true
    end
end
