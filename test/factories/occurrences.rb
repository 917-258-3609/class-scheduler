FactoryBot.define do
  factory :occurrence do
    transient do 
      start_time_s { "2022-08-01 14:00:00" }
    end
    start_time { Time.parse start_time_s }
    count { 1 }
    days { [start_time.wday] }
    period { 1.week }
    duration { 1.hour }
    schedule
  end
end
