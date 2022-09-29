FactoryBot.define do
  factory :schedule_recurrence do
    transient do
        start_time_t { 8.hours }
        end_time_t { 9.hours }
    end
    start_time_from_bow { Duration.parse start_time_t }
    end_time_from_bow { Duration.parse end_time_t }
    schedule
  end
end
