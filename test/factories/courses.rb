FactoryBot.define do
  factory :course do
    fee { "9.99" }
    location { "Zoom" }
    comment { "Special 1 to 1 olympiad level math class" }
    is_active { True }
  end
end
