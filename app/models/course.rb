class Course < ApplicationRecord
  has_and_belongs_to_many :students
  belongs_to :teacher
  has_one :schedule, as: :scheduleable
  belongs_to :subject_level
  has_toggled_attr(:active)

  # Validations
  validates_presence_of :teacher
  validates_presence_of :schedule
  validates_presence_of :subject_level

  validate :teacher_teaches_subject
  private
  def teacher_teaches_subject
    errors.add[:course, "Teacher must teaches the course subject level"] if \
      !self.teacher.teaches? self.subject_level
  end
    
end
