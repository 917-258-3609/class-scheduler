class Teacher < ApplicationRecord
    include PgSearch::Model
    
    has_and_belongs_to_many :subject_levels
    has_many :courses, dependent: :destroy
    has_one :schedule, as: :scheduleable, dependent: :destroy
    has_one :user, as: :accountable, dependent: :destroy
    
    validates_presence_of :user
    validates_presence_of :schedule
    validate :schedule_preference_recur_indefinitely
    validate :schedule_preference_is_weekly
    
    pg_search_scope :search_by_name, 
        against: [:name],
        using: :trigram 
    scope :teaches, ->(sl){joins(:subject_levels).where(
        "subject_levels.subject_id = ? AND subject_levels.level <= ?", sl.subject, sl.level
    )}
    def teaches?(sl)
        my_sl = self.subject_levels.for_subject(sl.subject)
        return !my_sl.empty? && (my_sl.first.level <= sl.level)
    end
    def self.generate_teacher_id(schedule, subject_level)
        t = self.teaches(subject_level).all.filter{|t|!t.has_course_overlapping(schedule)}.first
        return t && t.id
    end
    def has_course_overlapping(schedule)
      my_schedules = \
        self.courses.active.extract_associated(:schedule)
      return my_schedules.any?{|s| s.overlapping?(schedule)}
    end
    def total_teaching_hours_between(start_time, end_time)
        return self.courses.active.includes(:schedule).map{
            |c|c.schedule.total_time_between(start_time, end_time)/3600.0
        }.sum
    end
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
