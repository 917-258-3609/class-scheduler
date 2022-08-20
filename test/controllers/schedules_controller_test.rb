require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @schedule = FactoryBot.create(:schedule) 
  end

  test "should get index" do
    get schedules_url
    assert_response :success
  end

  test "should show schedule" do
    get schedule_url(@schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_schedule_url(@schedule)
    assert_response :success
  end

  # test "should update schedule" do
  #   patch schedule_url(@schedule), params: { schedule: {  } }
  #   assert_redirected_to schedule_url(@schedule)
  # end

end
