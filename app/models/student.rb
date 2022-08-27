class Student < ApplicationRecord
    include PgSearch::Model
    # Associations
    has_and_belongs_to_many :courses, optional: true
    has_one :schedule, as: :scheduleable, dependent: :destroy
    has_one :user, as: :accountable, dependent: :destroy
    # Validation
    validates_presence_of :schedule
    validates_presence_of :user
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly
    # Scope
    pg_search_scope :search_by_full_name, 
        against: [:first_name, :last_name],
        using: :trigram 
    # Callback
    before_validation :sanitize

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
    def sanitize
        self.first_name.capitalize!
        self.last_name.capitalize!
    end
end
