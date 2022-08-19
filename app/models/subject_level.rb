class SubjectLevel < ApplicationRecord
    include RailsSortable::Model

    has_and_belongs_to_many :teachers
    belongs_to :subject
    set_sortable :level, without_validations: true

    scope :for_subject, ->(subject){ where(subject: subject) }
    scope :by_level, ->{ order(:level) }

    validates :level, uniqueness: { scope: :subject }
    validates :level_name, uniqueness: { scope: :subject }
    def self.levels_by_subject
        return Subject.includes(:subject_levels).map do |s|
            SubjectLevel.for_subject(s).all
        end
    end
    def self.subjects = Subject.all.map(&:name) 
    def to_s
        return "#{self.level_name} #{self.subject.name}"
    end
end
