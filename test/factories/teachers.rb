FactoryBot.define do
  factory :teacher do
    name { "Peach" }
    user {
      association :user, 
      email: "#{name}@gmail.com"
    } 
    schedule
  end
end
