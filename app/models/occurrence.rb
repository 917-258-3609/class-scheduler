class Occurrence < ApplicationRecord

  # Association
  belongs_to :schedule, optional: true

  # Validation
  validates_presence_of :schedule
  validates_associated :schedule

  # Scope
  scope :overlapping_with, ->(st, et){where("start_time < ? AND ? < end_time", et, st)}
  scope :between, ->(st, et){where("? < start_time AND end_time < ?", st, et)}
  scope :chronological, ->{reorder("end_time ASC")}

  # Callback
  before_validation do
    self.start_time = self.start_time.utc
    self.end_time = self.end_time.utc
  end
  
  def occurs_on?(time) = self.start_time < time && time < self.end_time
  def occurring? = self.occurs_on?(Time.now)
  def overlapping?(o, travel_time: 0)
    return (self.start_time - travel_time <= o.end_time && o.start_time <= self.end_time + travel_time)
  end
  private
  # Validations
end
