class Course < ApplicationRecord
  has_and_belongs_to_many :students
  belongs_to :teacher
  has_one :schedule, as: :scheduleable
  belongs_to :subject_level
  has_toggled_attr :active

  # Validations
  validates_presence_of :teacher
  validates_presence_of :schedule
  validates_presence_of :subject_level

  validate :teacher_teaches_subject
  validate :teacher_schedule
  validate :student_schedule
  private
  def teacher_teaches_subject
    errors.add(:course, "Teacher must teaches the course subject level") if \
      !self.teacher.teaches?(self.subject_level)
  end
  def teacher_schedule
    other_schedules = \
      self.teacher.courses.active.where.not(id: self.id).extract_associated(:schedule)
    errors.add(:course, "Courses taught by the same teacher cannot overlap") if \
      other_schedules.any?{|s| s.overlapping?(self.schedule)}
  end
  def student_schedule
    return true if self.students.empty?
    other_schedules = \
      Schedule
      .joins("INNER JOIN courses 
                 ON schedules.scheduleable_id = courses.id 
                AND schedules.scheduleable_type = 'Course'")
      .where("courses.id != ? AND courses.is_active IS TRUE", self.id)
      .joins("INNER JOIN courses_students
                 ON courses_students.course_id = courses.id")
      .joins("INNER JOIN students
                 ON students.id = courses_students.student_id")
      .where("students.id": self.students.map(&:id))
    errors.add(:course, "Courses taught by the same teacher cannot overlap") if \
      other_schedules.any?{|s| s.overlapping?(self.schedule)}
  end
    
end
