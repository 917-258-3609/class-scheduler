module ConstructionHelper
  module Schedules 
    def create_schedules
      @olympiad_math_schedule = FactoryBot.create(:schedule)
      @regular_math_schedule = FactoryBot.create(:schedule)
      @regular_english_1_schedule = FactoryBot.create(:schedule)
      @regular_english_2_schedule = FactoryBot.create(:schedule)
      @lucifer_pref_schedule = FactoryBot.create(:schedule)
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