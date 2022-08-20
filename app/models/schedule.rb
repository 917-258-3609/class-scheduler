class Schedule < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true, optional: true
  has_many :occurrences, dependent: :destroy

  validate :occurrences_do_not_overlap
  validates_associated :scheduleable

  scope :for_course, ->{ where(scheduleable_type: "Course") }
  scope :for_student, ->{ where(scheduleable_type: "Student") }
  scope :for_teacher, ->{ where(scheduleable_type: "Teacher") }

  def inf_recur?
    !self.occurrences.inf_recur.empty?
  end
  def occurs_on?(time)
    self.occurrences.any?{|x|x.occurs_on?(time)} 
  end
  def occurring?
    self.occurs_on?(Time.now)
  end
  def occurred_count(time=Time.now)
    self.occurrences.map{|o|o.occurred_count(time)}.sum
  end
  def next_occurring_time(time=Time.now)
    return nil if self.occurrences.empty?
    next_occurrence = self.occurrences.all.map{|o|o.next_occurring_time(time)}.compact.min
    return next_occurrence
  end
  def overlapping?(s)
    return self.occurrences.any?{|my_o|s.occurrences.any?{|s_o| my_o.overlapping?(s_o)}}
  end

  def occurrences_between(start_time, end_time)
    return self.occurrences.map{|o|o.occurrences_between(start_time, end_time)}.flatten 
  end
  def occurrence_at(time)
    return self.occurrences.filter{|o|o.occurs_on?(time)}.first
  end
  def last_extended_recurrence(time) 
    recurrences = self.occurrences.all
    return nil if recurrences.any?{|o|o.inf_recur?}
    min_hash = recurrences
      .map{|r|{arg: r, val: r.extended_occurring_time}}
      .reduce{|h1, h2| h1.val < h2.val ? h1 : h2}
    return min_hash[:arg]
  end
  def create_recurrence(time, count, days, period, duration)
    return Occurrence.create(
      start_time: time,
      count: count,
      days: days,
      period: period,
      duration: duration,
      schedule: self
    )
  end
  def move_one(ftime, ttime)
    return false if !(o = occurrence_at(ftime))
    return o.move_occurrence(ftime, ttime)
  end
  def postpone(time)
    return false if !(o = occurrence_at(time))
    return o.delete_occurrence(time) && self.extend_one
  end
  def extend_one
    return true if !(o = self.last_extended_recurrence)
    return o.extend_recurrence
  end

  def teacher
    scheduleable if scheduleable.is_a? Teacher
  end
  def student 
    scheduleable if scheduleable.is_a? Student
  end
  def course 
    scheduleable if scheduleable.is_a? Course
  end
  private
  def occurrences_do_not_overlap
    return true if self.occurrences.count < 2
    self.occurrences.all.to_a.combination(2) do |a, b|
      if a.overlapping?(b)
        errors.add(:schedule, "occurrences in a schedule cannot overlap") 
        return false
      end
    end
    return true
  end
end
