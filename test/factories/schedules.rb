FactoryBot.define do
  factory :schedule do
    trait :for_course do
      association :scheduleable, factory: :course
    end

    trait :for_student do
      association :scheduleable, factory: :student
    end

    trait :for_teacher do
      association :scheduleable, factory: :teacher
    end
  end
end
