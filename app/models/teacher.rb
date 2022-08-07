class Teacher < ApplicationRecord
    has_and_belongs_to_many :subject_level
    has_many :courses
    has_one :schedule
    has_one :user
    
    validates_presence_of :user
    validates_presence_of :schedule
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly
    private
    def schedule_preference_is_weekly
        return true if self.schedule.nil?
        self.schedule.occurrences.all{|o|o.period == 1.week}
    end
    def schedule_preference_recur_indefinitely
        return true if self.schedule.nil?
        self.schedule.occurrences.all{|o|o.count.nil?}
    end
end
