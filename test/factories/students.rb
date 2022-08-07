FactoryBot.define do
  factory :student do
    first_name { "John" }
    last_name { "Doe" }
    schedule
    user {
      association :user,
      email: "#{first_name}#{last_name}@gmail.com"
    }
  end
end
