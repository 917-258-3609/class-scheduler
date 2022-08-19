class Subject < ApplicationRecord
    has_many :subject_levels
    validates_presence_of :name
    validates_uniqueness_of :name
end
