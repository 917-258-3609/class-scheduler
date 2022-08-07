FactoryBot.define do
  factory :course do
    fee { "9.99" }
    location { "Zoom" }
    comment { "Special 1 to 1 olympiad level math class" }
    is_active { true }
    teacher
    subject_level
  end
end
