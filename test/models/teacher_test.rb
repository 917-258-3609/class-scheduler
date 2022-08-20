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
    should "create and destroy teachers" do
    end
  end
end
