FactoryBot.define do
  factory :user do
    email { "defaultemail@gmail.com" }
    balance { "9.99" }
    is_active { true }
    trait :for_teacher do
      association :accountable, factory: :parent
    end
    trait :for_student do
      association :accountablt, factory: :student
    end
  end
end
