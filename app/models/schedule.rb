class Schedule < ApplicationRecord
  Duration = ActiveSupport::Duration

  belongs_to :scheduleable, polymorphic: true, optional: true
  has_many :occurrences, dependent: :destroy

  validate :occurrences_do_not_overlap
  validate :recurrences_do_not_overlap
  validates_associated :scheduleable

  scope :for_course, ->{ where(scheduleable_type: "Course") }
  scope :for_student, ->{ where(scheduleable_type: "Student") }
  scope :for_teacher, ->{ where(scheduleable_type: "Teacher") }

  def inf_recur?
    return self.end_time.nil? 
  end
  def occurs_on(time) = self.occurrences.overlapping_with(time, time).first
  def occurs_on?(time) = !!occurs_on(time) 
  def occurred_count(time=Time.now)
    self.occurrences.where("end_time < ?", time).count
  end
  
  def next_occurring_time(time=Time.now)
    return time if occurs_on(time)
    return (o = self.occurrences.where("start_time > ?", time).chronological.first) && o.start_time
  end
  def overlapping?(s)
    return false if s.nil? || s.occurrences.empty?
    t_time = self.travel_time(s)

    my_id_sql = sanitize_sql_array(["schedule_id == ?", self.id])
    s_id_sql = sanitize_sql_array(["o.schedule_id == ?", s.id])
    overlap_sql = sanitize_sql_array([
      "(start_time + interval '?') <= o.end_time AND o.start_time <= (end_time + interval '?')", 
      t_time, t_time
    ])
    return Occurrence
      .joins("INNER JOIN occurrences AS o 
                 ON #{my_id_sql} 
                AND #{s_id_sql} 
                AND #{overlap_sql}")
      .any?
  end
  def occurrences_between(start_time, end_time)
    return self.occurrences.between(start_time, end_time).all
  end
  def occurrence_at(time=Time.now)
    return self.occurrences.find_by start_time: time
  end
  def total_time_between(start_time, end_time)
    overlapping_occurrence = self.occurrences.overlapping_with(start_time, end_time).chronological
    cnt = overlapping_occurrence.count
    
    if cnt == 1
      f = overlapping_occurrence.first
      return [f.end_time, end_time].min - [f.start_time, start_time].max
    end    

    f = overlapping_occurrence.first
    l = overlapping_occurrence.last

    total_time = overlapping_occurrence[1...-1].map{|x|x.end_time - x.start_time}.sum
    total_time += f.end_time - [f.start_time, start_time].max
    total_time += [f.end_time, end_time].min - f.start_time
    return total_time
  end
  # Recurrence
  def next_recurrence
    recur_time = self.end_time
    loop do
      bow = recur_time.beginning_of_week
      time_from_bow = Duration.build(recur_time - bow)
      sorted_recurrences = self.schedule_recurrences.order("end_time_from_bow ASC")
      recurrences_after_time = sorted_recurrences.where("start_time_from_bow > ?", time_from_bow)
      if recurrences_after_time.any?
        ret = Occurrence.build(
          recurrences_after_time.first.start_time_from_bow + bow,
          recurrences_after_time.first.end_time_from_bow + bow
        )
      else
        ret = Occurrence.build(
          sorted_recurrences.first.start_time_from_bow + bow + 1.week,
          sorted_recurrences.first.end_time_from_bow + bow + 1.week
        )
      end
      return ret if !self.occurrences.overlapping_with(ret.start_time, ret.end_time).any?
      recur_time = ret.end_time
    end
  end
  def next_recurrences(until_condition)
    cnt = 0
    recurring_occurrences = []
    bow = self.end_time.beginning_of_week
    time_from_bow = Duration.build(self.end_time - bow)

    sorted_recurrences = self.schedule_recurrences.order("end_time_from_bow ASC")
    recurrences_after_time = sorted_recurrences.where("start_time_from_bow >= ?", time_from_bow)
    future_occurrences = self.occurrences.where("start_time >= ?", self.end_time).chronological.all
    
    recurrences_after_time.each do |r|
      break if until_condition({count: cnt, time: r.end_time_from_bow+bow})
      o = Occurrence.build(
        r.start_time_from_bow + bow,
        r.end_time_from_bow + bow
      )
      next if future_occurrences.any?{|x|x.overlapping?(o)}
      recurring_occurrences.append(o)
      cnt++
    end
    loop do
      bow += 1.week
      break if !sorted_recurrences.each do |r|
        break if until_condition({count: cnt, time: r.end_time_from_bow+bow})
        o = Occurrence.build(
          r.start_time_from_bow + bow,
          r.end_time_from_bow + bow
        )
        next if future_occurrences.any?{|x|x.overlapping?(o)}
        recurring_occurrences.append(o)
        cnt++
      end
    end
    return recurring_occurrences
  end
  # TODO: Wrap actions in transaction
  # Actions
  def remove_one(time)
    return (o = self.occurrence_at(time)) && o.destroy
  end
  def add_one(stime, etime)
    return false if !(o = Occurrence.create(start_time: stime, end_time: etime))
    return (self << o)
  end
  def move_one(ftime, ttime)
    return false if !(o = self.occurrence_at(ftime))
    tend_time = ttime + (o.end_time - o.start_time)
    return o.update(start_time: ttime, end_time: tend_time)
  end
  def extend_one
    return extend_count(1) 
  end
  def postpone(time)
    return (self.extend_one && self.remove_one(time))
  end
  # TODO: Maybe set start_time
  def extend_count(c)
    until_count = ->(params){params[:count] == c}
    return (self << (o = self.next_recurrences(until_count)) && self.end_time = o[-1].end_time)
  end
  def extend_time(d)
    until_time = ->(params){params[:time] >= (self.end_time + d)}
    return (self << (o = self.next_recurrences(until_time)) && self.end_time = o[-1].end_time)
  end

  def teacher
    scheduleable if scheduleable.is_a? Teacher
  end
  def is_for_teacher?
    self.scheduleable_type == "Teacher"
  end
  def student 
    scheduleable if scheduleable.is_a? Student
  end
  def is_for_student?
    self.scheduleable_type == "Student"
  end
  def course 
    scheduleable if scheduleable.is_a? Course
  end
  def is_for_course?
    self.scheduleable_type == "Course"
  end
  private
  def occurrences_do_not_overlap
    return true if self.occurrences.size < 2
    t_time = self.travel_time(self)
    
    overlap_sql = sanitize_sql_array([
      "(start_time + interval '?') <= o.end_time AND o.start_time <= (end_time + interval '?')", 
      t_time, t_time
    ])
    my_occurrences_sql = self.occurrences.to_sql
    return !self.occurrences.joins(
      "INNER JOIN (#{my_occurrences_sql}) as o
          ON id != o.id
         AND #{overlap_sql}"
    ).any?
  end
  def recurrences_do_not_overlap
    return true if self.schedule_recurrences.size < 2
    t_time = self.travel_time(self)
    
    overlap_sql = sanitize_sql_array([
      "(start_time_from_bow + interval '?') <= o.end_time_from_bow AND 
                      o.start_time_from_bow <= (end_time_from_bow + interval '?')", 
      t_time, t_time
    ])
    my_recurrences_sql = self.schedule_recurrences.to_sql
    return !self.schedule_recurrences.joins(
      "INNER JOIN (#{my_recurrences_sql}) as o
          ON id != o.id
         AND #{overlap_sql}"
    ).any?
  end
  # TODO: store in db
  def travel_time(s)
    return 0 unless self.is_for_course? && s.is_for_course?
    return 15.minutes if self.course.location == "Zoom" && s.course.location == "Zoom"
    return 1.hour
  end
end
