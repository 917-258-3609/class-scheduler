require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  should belong_to(:scheduleable).optional
  context "schedules" do
    setup do
      create_schedules
      create_occurrences
    end
    # teardown do
    #   destroy_occurrences
    #   destroy_schedules
    # end
    should "have overlapping? to determine if 2 schedule overlaps" do
      assert_overlapping(@lucifer_pref_schedule, @olympiad_math_schedule)
      assert_not_overlapping(@olympiad_math_schedule, @regular_english_1_schedule)
    end
    should "have occurs_on to determine if the event occurs on give time" do
      subject = @lucifer_pref_schedule
      start_time = @every_monday_1400_3.start_time
      assert(subject.occurs_on?(start_time))
      assert(subject.occurs_on?(start_time+1.week+1.day+1.hour))
      assert(!subject.occurs_on?(start_time+1.week+1.day+3.hour))
      assert(!@empty_schedule.occurs_on?(Time.now))
    end
    should "have occurred_count to determine the occurred count" do
      assert_equal(1, @olympiad_math_schedule.occurred_count(Time.parse "2022-07-22 15:00:00 UTC"))
      assert_equal(2, @olympiad_math_schedule.occurred_count(Time.parse "2022-07-28 15:00:00 UTC"))
      assert_equal(3, @olympiad_math_schedule.occurred_count(Time.parse "2022-08-03 15:00:00 UTC"))
    end
    should "have next_occurrence to determine the next occurrence in a schedule" do
      assert_equal((Time.parse "2022-07-19 15:00:00 UTC"), 
        @olympiad_math_schedule.next_occurring_time(Time.parse "2022-07-19 14:00:00 UTC")
      )
      assert_equal((Time.parse "2022-08-01 14:00:00 UTC"), 
        @olympiad_math_schedule.next_occurring_time(Time.parse "2022-07-28 19:00:00 UTC")
      )
    end
    should "not allow overlapping occurrences in same schedule" do
      assert(@lucifer_pref_schedule.valid?)
      @testing_occurrence = FactoryBot.create(:occurrence, 
        schedule: @lucifer_pref_schedule, start_time: "2022-08-01 14:30:00", count: 3
      )
      assert_overlapping(@testing_occurrence, @every_monday_1400_inf)
      assert(!@lucifer_pref_schedule.valid?)
      assert(!@testing_occurrence.valid?)
      @testing_occurrence.delete

      @testing_occurrence = FactoryBot.create(:occurrence, 
        schedule: @regular_english_2_schedule, start_time: "2022-08-01 14:30:00", period: nil
      )
      assert(!@regular_english_2_schedule.valid?)
      assert(!@testing_occurrence.valid?)
    end
    should "have move one method that moves one occurrence" do
      ftime = Time.parse("2022-08-08 14:00:00 UTC")
      ttime = Time.parse("2022-08-11 14:00:00 UTC")
      assert(@lucifer_pref_schedule.occurrence_at(ftime))
      assert(@lucifer_pref_schedule.move_one(ftime, ttime))
      assert(!@lucifer_pref_schedule.occurs_on?(ftime))
      assert(@lucifer_pref_schedule.occurs_on?(ttime))
    end
  end
  private
  def assert_overlapping(o1, o2)
    assert(o1.overlapping?(o2))
    assert(o2.overlapping?(o1))
  end
  def assert_not_overlapping(o1, o2)
    assert(!o1.overlapping?(o2))
    assert(!o2.overlapping?(o1))
  end
end
