module ConstructionHelper
  module Courses
    def create_courses
      @olympiad_math_course = FactoryBot.create(:course, 
        fee: 10000, 
        teacher: @melon,
        subject_level: @olympiad_math,
        schedule: @olympiad_math_schedule
      )
      @regular_math_course = FactoryBot.create(:course,
        fee: 5000,
        teacher: @melon,
        subject_level: @regular_math,
        schedule: @regular_math_schedule
      )
      @regular_english_course_1 = FactoryBot.create(:course,
        fee: 1000,
        teacher: @peach,
        subject_level: @regular_english,
        schedule: @regular_english_1_schedule
      )
      @nobel_science_course = FactoryBot.create(:course,
        fee: 12000,
        teacher: @peach,
        subject_level: @nobel_science,
        schedule: @nobel_science_schedule
      )
      @regular_english_course_2 = FactoryBot.create(:course,
        fee: 1500,
        teacher: @apple,
        subject_level: @regular_english,
        schedule: @regular_english_2_schedule
      )
    end
    def destroy_courses
      @olympiad_math_course.destroy
      @regular_english_course_1.destroy
      @regular_english_course_2.destroy
      @nobel_science_course.destroy
      @regular_math_course.destroy
    end
  end
end