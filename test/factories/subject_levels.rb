FactoryBot.define do
  factory :subject_level do
    transient do
      subject_name { "Math" } 
    end
    subject { association :subject, name: subject_name}
    level { 1 }
    level_name { "Regular" }
  end
end
