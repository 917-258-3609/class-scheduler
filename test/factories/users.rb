FactoryBot.define do
  factory :user do
    email { "defaultemail@gmail.com" }
    balance { 0.0 }
    is_active { true }
    trait :for_teacher do
      association :accountable, factory: :teacher
    end
    trait :for_student do
      association :accountable, factory: :student
    end
  end
end
