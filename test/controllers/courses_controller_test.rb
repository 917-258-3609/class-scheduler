require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do 
    create_subjects
    create_subject_levels
    create_students
    create_teachers
    create_schedules
    create_courses
  end
  test "should get show" do
    get course_path(@olympiad_math_course)
    assert_response :success
  end

  test "should get index" do
    get courses_path
    assert_response :success
  end

  test "should get new" do
    get new_course_path
    assert_response :success
  end

  test "should get edit" do
    get edit_course_path(@olympiad_math_course)
    assert_response :found
  end

end
