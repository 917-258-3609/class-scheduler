class SubjectLevel < ApplicationRecord
    has_and_belongs_to_many :teachers
    
    scope :for_subject, ->(subject){ where(subject: subject) }
    scope :by_rank, ->{ order(:level) }

    validates :level, uniqueness: { scope: :subject }
   
    def self.subjects = self.distinct.pluck(:subject)
    def to_s
        return "#{self.level_name} #{self.subject}"
    end
end
