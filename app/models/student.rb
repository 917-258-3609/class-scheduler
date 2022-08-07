class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    has_one :schedule
    has_one :user

    validates_presence_of :schedule
    validates_presence_of :user
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly
    private
    def schedule_preference_is_weekly
        self.schedule.occurrences.all.all?{|o|o.period == 1.week}
    end
    def schedule_preference_recur_indefinitely
        self.schedule.occurrences.all.all?{|o|o.count.nil?}
    end
end
