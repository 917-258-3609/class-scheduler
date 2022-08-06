class Schedule < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true
  has_many :occurrences

  def occurs_on?(time)
    self.occurrences.not_negative.any?{|x|x.occurs_on?(time)} &&
    self.occurrences.negative.all?{|x|!x.occurs_on?(time)} 
  end
  def occurring?
    self.occurs_on?(Time.now)
  end
  def next_occurrence
    # TODO: handle if schedule is empty
    next_occurrence = self.occurrences
                           .map{|o|o.next_occurrence}
                           .filter{|x|!x.nil?}
                           .min
    return next_occurrence
  end
  def overlapping?(s)
    return self.occurrences.any?{|my_o|s.occurrences.any?{|s_o| my_o.overlapping?(s_o)}}
  end

end
