require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  context "teachers" do
    setup do
      create_subjects
      create_subject_levels
      create_teachers
    end
    # teardown do
    #   destroy_teachers
    #   destroy_subject_levels
    # end
    should "have total_teaching_hours_between that summarize total teaching time" do
      create_schedules
      create_courses

      btime = Time.parse("2022-08-01 14:00:00")
      etime = Time.parse("2022-08-06 14:00:00")
      
      assert_equal(4.0, @peach.total_teaching_hours_between(
        btime, etime
      ))
    end
  end
end
