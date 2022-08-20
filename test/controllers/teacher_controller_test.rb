require "test_helper"

class TeacherControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_subjects
    create_subject_levels
    create_teachers
  end
  test "should get index" do
    get teachers_path 
    assert_response :success
  end

  test "should get show" do
    get teacher_path(@peach)
    assert_response :success
  end

  test "should get new" do
    get new_teacher_path
    assert_response :success
  end

  test "should get edit" do
    get edit_teacher_path(@peach)
    assert_response :success
  end
 
end
