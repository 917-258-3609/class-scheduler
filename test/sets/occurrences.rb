module ConstructionHelper
  module Occurrences
    def create_occurrences
      @every_monday_1400_inf = FactoryBot.create(:occurrence, 
        schedule: @lucifer_pref_schedule, start_time_s: "2022-08-01 14:00:00", count: nil
      )
      @every_tuesday_1400_inf = FactoryBot.create(:occurrence, 
        schedule: @lucifer_pref_schedule, start_time_s: "2022-08-02 14:00:00", count: nil, duration: 2.hours
      )
      @every_monday_1400_3 = FactoryBot.create(:occurrence, 
        schedule: @olympiad_math_schedule, start_time_s: "2022-08-01 14:00:00", count: 3
      )
      @every_monday_1500_3 = FactoryBot.create(:occurrence, 
        schedule: @regular_math_schedule, start_time_s: "2022-08-01 15:15:00", count: 3
      )
      @every_tuesday_1400_20 = FactoryBot.create(:occurrence, 
        schedule: @regular_english_1_schedule, start_time_s: "2022-08-02 14:00:00", count: 20
      )
      @every_wednesday_1500_20 = FactoryBot.create(:occurrence, 
        schedule: @nobel_science_schedule, start_time_s: "2022-08-03 15:00:00", count: 20, days: [0,3,4,5]
      )
      @every_tuesday_1500_20 = FactoryBot.create(:occurrence, 
        schedule: @regular_english_2_schedule, start_time_s: "2022-08-02 15:00:00", count: 20
      )
      @every_tuesday_1500_2_early = FactoryBot.create(:occurrence, 
        schedule: @olympiad_math_schedule, start_time_s: "2022-07-19 15:00:00", count: 2
      )
      @every_tuesday_1500_3_early = FactoryBot.create(:occurrence, 
        start_time_s: "2022-07-19 15:00:00", count: 3
      )
      @monday_1400 = FactoryBot.create(:occurrence, 
        schedule: @regular_english_2_schedule, start_time_s: "2022-08-01 14:00:00"
      )
      @monday_1430 = FactoryBot.create(:occurrence,
        start_time_s: "2022-08-01 14:30:00", duration: 30.minutes
      )
      @monday_1500 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 15:00:00"
      )
    end
    def destroy_occurrences
      @every_monday_1400_inf.delete
      @every_monday_1400_3.delete
      @every_monday_1500_3.delete
      @every_tuesday_1400_20.delete
      @every_tuesday_1500_20.delete
      @every_tuesday_1500_2_early.delete
      @every_tuesday_1500_3_early.delete
      @monday_1400.delete
      @monday_1430.delete
    end
  end
end