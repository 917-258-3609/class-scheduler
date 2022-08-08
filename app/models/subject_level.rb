class SubjectLevel < ApplicationRecord
    has_and_belongs_to_many :teachers
    validates :level, uniqueness: { scope: :subject }
    
    def to_s
        return "#{self.level_name} #{self.subject}"
    end
end
