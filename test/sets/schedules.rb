module ConstructionHelper
  module Schedules 
    def create_schedules
      @olympiad_math_schedule = FactoryBot.create(:recurring_schedule, 
        recurrences: [
          {dow: 1, start_time_from_bod: 14.hours, duration: 1.hour}
        ],
        count: 3,
        start_time_s: "2022-08-01 14:00:00"
      )
      FactoryBot.create(:occurrence, schedule: @olympiad_math_schedule,
        start_time_s: "2022-07-19 15:00:00", end_time_s: "2022-07-19 16:00:00"
      )
      FactoryBot.create(:occurrence, schedule: @olympiad_math_schedule,
        start_time_s: "2022-07-26 15:00:00", end_time_s: "2022-07-26 16:00:00"
      )

      @regular_math_schedule = FactoryBot.create(:recurring_schedule, 
        recurrences: [
          {dow: 1, start_time_from_bod: 15.hours+15.minutes, duration: 1.hour}
        ],
        count: 3,
        start_time_s: "2022-08-01 15:15:00"
      )
      FactoryBot.create(:occurrence, schedule: @regular_math_schedule,
        start_time_s: "2022-08-22 15:30:00", end_time_s: "2022-08-22 16:15:00"
      )

      @regular_english_1_schedule = FactoryBot.create(:recurring_schedule,
        recurrences: [
          {dow: 2, start_time_from_bod: 14.hours, duration: 1.hour}
        ],
        count: 20,
        start_time_s: "2022-08-02 14:00:00"
      )

      @regular_english_2_schedule = FactoryBot.create(:recurring_schedule,
        recurrences: [
          {dow: 2, start_time_from_bod: 15.hours, duration: 1.hour}
        ],
        count: 20,
        start_time_s: "2022-08-02 15:00:00"
      )
      FactoryBot.create(:occurrence, schedule: @regular_english_2_schedule,
        start_time_s: "2022-07-26 15:00:00", end_time_s: "2022-07-26 16:00:00"
      )


      @nobel_science_schedule = FactoryBot.create(:recurring_schedule,
        recurrences: [
          {dow: 0, start_time_from_bod: 15.hours, duration: 1.hour},
          {dow: 3, start_time_from_bod: 15.hours, duration: 1.hour},
          {dow: 4, start_time_from_bod: 15.hours, duration: 1.hour},
          {dow: 5, start_time_from_bod: 15.hours, duration: 1.hour}
        ],
        count: 20,
        start_time_s: "2022-08-03 15:00:00"
      )

      @lucifer_pref_schedule = FactoryBot.create(:recurring_schedule,
        recurrences: [
          {dow: 1, start_time_from_bod: 14.hours, duration: 1.hour},
          {dow: 2, start_time_from_bod: 14.hours, duration: 2.hour}
        ],
        count: 40,
        start_time_s: "2022-08-01 14:00:00"
      )
      @empty_schedule = FactoryBot.create(:schedule)
    end
    def destroy_schedules
      @olympiad_math_schedule.delete
      @regular_math_schedule.delete
      @regular_english_1_schedule.delete
      @regular_english_2_schedule.delete
      @lucifer_pref_schedule.delete
    end
  end
end