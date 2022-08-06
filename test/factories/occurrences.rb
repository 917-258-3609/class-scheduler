FactoryBot.define do
  factory :occurrence do
    start_time { "2022-08-01 14:00:00" }
    count { 1 }
    period { 1.week }
    duration { 1.hour }
  end
end
