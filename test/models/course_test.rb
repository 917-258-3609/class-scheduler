require "test_helper"

class CourseTest < ActiveSupport::TestCase
  context "courses" do
    setup do
      create_subject_levels
      create_teachers
      create_occurrences
      create_schedules
      create_courses  
    end
    should "create and destroy courses" do
    end
  end
end
