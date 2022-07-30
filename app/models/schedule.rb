class Schedule < ApplicationRecord
  belongs_to :scheduleable, polymorphic: true
end
