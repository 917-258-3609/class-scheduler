require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "users" do
    setup do
      create_subjects
      create_subject_levels
      create_students
      create_teachers
      create_users
    end
    should "create and destroy users" do 
    end
    should "have teacher accessor for teacher account" do
      assert_not_nil(@peach.user.teacher)
      assert_nil(@peach.user.student)
    end
    should "have student accessor for student account" do
      assert_not_nil(@lucifer_lombardi.user.student)
      assert_nil(@lucifer_lombardi.user.teacher)
    end
  end
end
