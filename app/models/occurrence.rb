require 'active_support/time'
class Occurrence < ApplicationRecord
  Duration = ActiveSupport::Duration

  # Association
  belongs_to :schedule, optional: true

  # Validation
  validates :duration, presence: true, comparison: {other_than: 0}
  validates :period, presence: true, comparison: {other_than: 0}
  validate :duration_is_shorter_than_period
  validate :start_time_is_in_days
  validates_associated :schedule

  # Scope
  scope :inf_recur, -> { where("count IS NULL") }
  scope :fin_recur, -> { where("count IS NOT NULL") }

  # Callback
  before_validation do
    self.start_time = self.start_time.utc
  end
  before_save do
    self.ice_cube_b = self.ice_cube.to_hash
  end

  def inf_recur? = self.count.nil?
  def occurs_on?(time) = self.ice_cube.occurring_at?(time)
  def occurring? = self.occurs_on?(Time.now)
  def occurred_count(time=Time.now) 
    self.ice_cube.occurrences_between(self.start_time, time).size
  end
  def next_occurring_time(time=Time.now)
    return time if self.occurs_on?(time)
    self.ice_cube.next_occurrence(time, spans: true)
  end
  def last_occurring_time
    self.ice_cube.last + self.duration
  end
  # Temporarily increase count by one in ice cube to check the extended time
  def extended_occurring_time
    return nil if !self.extend_one
    ret = self.last_occurring_time
    self.count-=1
    self.clear_ice_cube
    return ret
  end
  # Temporarily adjust ice cube start time and duration for travel time
  def account_for_travel_time(t)
    self.ice_cube.start_time = self.ice_cube.start_time - t
    self.ice_cube.duration = self.ice_cube.duration + t
  end
  def overlapping?(o, travel_time: 0)
    # TODO: throw error here instead
    # assert(self.one_time? || self.period == 1.week)
    # assert(o.one_time? || o.period == 1.week)
    # assert(self.duration < 1.day && o.duration < 1.day)
    self.account_for_travel_time(travel_time) if travel_time != 0
    ret = self.ice_cube.conflicts_with?(o.ice_cube, [ 
      self.end_time || o.end_time || Time.now + 1.year, 
      o.end_time || self.end_time || Time.now + 1.year
    ].min )
    self.clear_ice_cube if travel_time != 0
    return ret
  end
  def occurrences_between(start_time, end_time)
    self.ice_cube.occurrences_between(start_time, end_time)
  end
  def create_occurrence(time)
    self.add_time(time) &&
    self.save
  end
  def move_occurrence(ftime, ttime)
    self.remove_time(ftime) &&
    self.add_time(ttime) &&
    self.save
    return true
  end
  def delete_occurrence(time)
    self.remove_time(time) &&
    self.save
  end
  def extend_recurrence(c=1)
    self.extend_many(c) &&
    self.save
  end
  def ice_cube
    return @ice_cube if @ice_cube
    return (@ice_cube = IceCube::Schedule.from_hash(self.ice_cube_b)) if self.ice_cube_b
    return build_ice_cube 
  end
  def clear_ice_cube
    @ice_cube = nil
    self.ice_cube
  end
  private
  # Validations
  def duration_is_shorter_than_period
    errors.add(:occurrence, "Duration must be smaller than period") if \
      self.duration > self.period
  end
  def start_time_is_in_days
    return true if self.period != 1.week
    errors.add(:occurrence, "Start time must be a recurring day") if \
      !self.days.include?(self.start_time.localtime.wday) 
  end

  def intersects?(time)
    return self.ice_cube.occurring_at?(time) ||
           self.ice_cube.occurring_at?(time+self.duration)
  end
  def add_time(time)
    return false if self.intersects?(time)
    self.ice_cube.add_recurrence_time(time) if \
      !self.ice_cube.remove_exception_time(time)
  end
  def remove_time(time)
    return false if !self.occurs_on?(time) 
    self.ice_cube.add_exception_time(time) if \
      !self.ice_cube.remove_recurrence_time(time)
  end
  def extend_many(c)
    return false if !(recurrence = self.ice_cube.recurrence_rules.first)
    self.count+=c
    recurrence.count(self.count)
  end
  def extend_one
    return extend_many(1)
  end
  def build_ice_cube
    @ice_cube = IceCube::Schedule.new(self.start_time, duration: self.duration)
    case self.period
    when 1.day
      @ice_cube.add_recurrence_rule(IceCube::Rule.daily.count(self.count))
    when 1.week
      @ice_cube.add_recurrence_rule(IceCube::Rule
        .weekly
        .day(self.days)
        .count(self.count)
      )
    else
      @ice_cube = nil
    end
    return @ice_cube
  end
end
