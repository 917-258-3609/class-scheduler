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
  factory :recurring_schedule, parent: :schedule do
    transient do
      recurrences {[{dow: 0, start_time_from_bod: 8.hours, duration: 1.hour}]}
      count { 1 }
      start_time_s { "2022-08-01 08:00:00 UTC" }
    end
    start_time { Time.parse start_time_s}
    after(:create) do |schedule, evaluator|
      evaluator.recurrences.each{|r| FactoryBot.create(:schedule_recurrence,
        start_time_t: r[:dow].days + r[:start_time_from_bod],
        end_time_t: r[:dow].days + r[:start_time_from_bod] + r[:duration],
        schedule: schedule
      )}
      schedule.extend_count(evaluator.count)
    end
  end
end
