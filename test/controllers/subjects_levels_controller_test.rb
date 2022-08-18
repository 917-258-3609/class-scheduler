require "test_helper"

class SubjectLevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_subject_levels
  end
  test "should get index" do
    get subject_levels_path
    assert_response :success
  end

  test "should get new" do
    get new_subject_level_path
    assert_response :success
  end
end
