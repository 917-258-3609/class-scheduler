class SubjectLevel < ApplicationRecord
    has_and_belongs_to_many :teachers
    validates :level, uniqueness: { scope: :subject } 
end
