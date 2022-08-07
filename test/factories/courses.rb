FactoryBot.define do
  factory :course do
    fee { 9.99 }
    location { "Zoom" }
    comment { "#{subject_level.level_name} level #{subject_level.subject} class taught by #{teacher.name}" }
    is_active { true }
    teacher
    subject_level
    schedule
  end
end
