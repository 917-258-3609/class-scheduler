FactoryBot.define do
  factory :occurrence do
    transient do
      start_time_s { "2022-08-01 08:00:00 "}
      end_time_s { "2022-08-01 08:00:00 "}
    end
    start_time { Time.find_zone("UTC").parse start_time_s.to_time }
    end_time { Time.find_zone("UTC").parse end_time_s.to_time }
    schedule
  end
end
