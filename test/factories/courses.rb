FactoryBot.define do
  factory :course do
    fee { 999 }
    location { "Zoom" }
    comment { "#{subject_level.level_name} level #{subject_level.subject} class taught by #{teacher.name}" }
    name { "#{subject_level.to_s} #{teacher.name}" }
    is_active { true }
    teacher
    subject_level
    schedule
  end
end
