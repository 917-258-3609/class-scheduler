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
    next_occurrences = self.occurrences
                           .map{|o|o.next_occurrence}
                           .filter{|x|!x.nil?}
                           .reduce{|x,y| if x < y then x else y}
  end

end
