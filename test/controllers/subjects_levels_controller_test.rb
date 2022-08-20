require "test_helper"

class SubjectLevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_subjects
    create_subject_levels
  end

  test "should get new" do
    get new_subject_level_path
    assert_response :success
  end

  test "should create subject level" do
    lsize = SubjectLevel.count
    post subject_levels_url, params: {subject_level: {
      level_name: "Basic",
      subject: "Math"
    }}
    assert_response :found
    assert(SubjectLevel.count == lsize+1)
    assert(
      !SubjectLevel.where(
        level_name: "Basic", 
        level: 3, 
        subject_id: @math.id
      ).empty?
    )

  end
end
