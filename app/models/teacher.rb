class Teacher < ApplicationRecord
    has_and_belongs_to_many :subject_level
    has_many :courses
    has_one :schedule
    has_one :user
    
    validate_presence_of :schedule
    validate_presence_of :user
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly
    private
    def schedule_preference_is_weekly
        self.schedule.occurrences.all{|o|o.period == 1.week}
    end
    def schedule_preference_recur_indefinitely
        self.schedule.occurrences.all{|o|o.count == -1}
    end
end
