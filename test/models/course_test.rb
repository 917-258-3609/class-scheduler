require "test_helper"

class CourseTest < ActiveSupport::TestCase
  context "courses" do
    setup do
      create_subjects
      create_subject_levels
      create_schedules
      create_occurrences
      create_teachers
      create_students
      create_courses  
    end
    should "have teacher that teaches the subject" do
      c1 = FactoryBot.build(:course, 
        teacher: @apple, 
        subject_level: @olympiad_math,
        schedule: @empty_schedule
      )
      assert(!c1.valid?)
      c1.teacher = @melon
      assert(c1.valid?)
      c1.subject_level = @regular_english
      assert(!c1.valid?)
    end
    should "ensure courses of the same teacher do not overlap" do
      assert(
        !@olympiad_math_course.schedule.overlapping?(@regular_math_course.schedule)
      )
      bad_schedule = FactoryBot.build(:schedule)
      bad_schedule.occurrences << FactoryBot.build(:occurrence,
        schedule: bad_schedule,
        start_time_s: "2022-08-01 14:30:00", 
        count: 2
      )
      assert(bad_schedule.overlapping?(@olympiad_math_course.schedule))
      @regular_math_course.schedule = bad_schedule
      assert(!@regular_math_course.valid?)
    end
    should "ensure courses of the same student do not overlap" do
      assert(@regular_english_course_2.valid?)
      assert(@olympiad_math.valid?)
      assert(@olympiad_math_schedule.overlapping?(@regular_english_2_schedule))
      @mark_perry.courses = [@regular_english_course_2]
      assert(@regular_english_course_2.valid?)
      assert(@olympiad_math.valid?)
      @mark_perry.courses = [@regular_english_course_2, @olympiad_math_course]
      assert(!@regular_english_course_2.valid?)
      assert(!@olympiad_math_course.valid?)
    end
  end
end
