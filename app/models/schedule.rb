class Schedule < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true, optional: true
  has_many :occurrences

  validate :occurrences_do_not_overlap

  def occurs_on?(time)
    self.occurrences.all.any?{|x|x.occurs_on?(time)} 
  end
  def occurring?
    self.occurs_on?(Time.now)
  end
  def occurred_count(time=Time.now)
    self.occurrences.all.map{|o|o.occurred_count(time)}.sum
  end
  def next_occurring_time(time=Time.now)
    # TODO: handle if schedule is empty
    return nil if self.occurrences.all.empty?
    next_occurrence = self.occurrences.all.map{|o|o.next_occurring_time(time)}.compact.min
    return next_occurrence
  end
  def overlapping?(s)
    return self.occurrences.all.any?{|my_o|s.occurrences.all.any?{|s_o| my_o.overlapping?(s_o)}}
  end
  private
  def occurrences_do_not_overlap
    self.occurrences.all.to_a.combination(2) do |a, b|
      if a.overlapping?(b)
        errors.add(:schedule, "occurrences in a schedule cannot overlap") 
        return false
      end
    end
    return true
  end
end
