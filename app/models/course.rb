class Course < ApplicationRecord
    has_and_belongs_to_many :students
    belongs_to :teacher
    has_one :schedule
    belongs_to :subject_level
    has_toggleable_attr(:active)
end
