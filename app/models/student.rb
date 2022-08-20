class Student < ApplicationRecord
    include PgSearch::Model

    has_and_belongs_to_many :courses, optional: true
    has_one :schedule, as: :scheduleable, dependent: :destroy
    has_one :user, as: :accountable, dependent: :destroy

    validates_presence_of :schedule
    validates_presence_of :user
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly

    pg_search_scope :search_by_full_name, 
        against: [:first_name, :last_name],
        using: :trigram 

    def name
        return "#{self.first_name} #{self.last_name}"
    end
    private
    def schedule_preference_is_weekly
        self.schedule.occurrences.all.all?{|o|o.period == 1.week}
    end
    def schedule_preference_recur_indefinitely
        self.schedule.occurrences.all.all?{|o|o.count.nil?}
    end
end
