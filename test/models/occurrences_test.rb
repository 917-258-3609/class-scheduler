require "test_helper"

class OccurrenceTest < ActiveSupport::TestCase
  context "occurrences" do
    setup do
      create_occurrences
    end
    # teardown do
    #   destroy_occurrences
    # end
    should "have overlapping? method that detect if two occurrences overlaps" do
      assert_overlapping(@every_monday_1400_3, @every_monday_1400_inf)
      assert_overlapping(@every_monday_1400_3, @monday_1400)
      assert_overlapping(@every_monday_1400_3, @monday_1430)
      assert_overlapping(@every_tuesday_1500_2_early, @every_tuesday_1500_3_early)
      assert_overlapping(@every_tuesday_1500_20, @every_tuesday_1500_3_early)

      assert_not_overlapping(@every_monday_1400_inf, @every_tuesday_1400_20)
      assert_not_overlapping(@every_tuesday_1500_20, @every_tuesday_1400_20)
      assert_not_overlapping(@every_tuesday_1400_20, @every_tuesday_1500_2_early)
      assert_not_overlapping(@monday_1400, @monday_1500)
      assert_not_overlapping(@every_monday_1400_inf, @monday_1500)
      assert_not_overlapping(@every_tuesday_1500_20, @monday_1500)
    end
    should "have occurred_count method for finite event" do
      subject = @every_monday_1400_3
      start_time = subject.start_time
      period = subject.period

      assert_equal(1, subject.occurred_count(start_time))
      assert_equal(1, subject.occurred_count(start_time+1.hour))
      assert_equal(1, subject.occurred_count(start_time+30.minutes))
      assert_equal(0, subject.occurred_count(start_time - 1.hour))
      assert_equal(1, subject.occurred_count(start_time + 2.hour))
      assert_equal(2, subject.occurred_count(start_time+period+2.hour))
      assert_equal(3, subject.occurred_count(start_time + 2*period+2.hour))
    end
    should "have next_occurring_time method for finite event" do
      subject = @every_monday_1400_3
      start_time = subject.start_time
      period = subject.period

      assert_equal(start_time, subject.next_occurring_time(start_time))
      assert_equal(start_time+1.week, subject.next_occurring_time(start_time+1.hour))
      assert_equal(start_time+30.minutes, subject.next_occurring_time(start_time+30.minutes))
      assert_equal(start_time, subject.next_occurring_time(start_time - 1.hour))
      assert_equal(start_time + period, subject.next_occurring_time(start_time + 2.hour))
      assert_equal(start_time + 2*period, subject.next_occurring_time(start_time+period+2.hour))
      assert_nil(subject.next_occurring_time(start_time + 2*period+2.hour))
    end
    should "have occurred_count for infinite event" do
      subject = @every_monday_1400_inf
      start_time = subject.start_time
      period = subject.period

      assert_equal(1, subject.occurred_count(start_time))
      assert_equal(1, subject.occurred_count(start_time+1.hour))
      assert_equal(0, subject.occurred_count(start_time - 1.hour))
      assert_equal(3, subject.occurred_count(start_time + 2*period+2.hour))
      assert_equal(100, subject.occurred_count(start_time + 99*period+2.hour))
    end
    should "have next_occurring_time for infinite event" do
      subject = @every_monday_1400_inf
      start_time = subject.start_time
      period = subject.period

      assert_equal(start_time, subject.next_occurring_time(start_time))
      assert_equal(start_time+30.minutes, subject.next_occurring_time(start_time+30.minutes))
      assert_equal(start_time,subject.next_occurring_time(start_time - 1.hour))
      assert_equal(start_time + 3*period,
                   subject.next_occurring_time(start_time + 2*period+2.hour))
    end
    should "have occurred_count for one time event" do
      subject = @monday_1400
      start_time = subject.start_time
      period = subject.period

      assert_equal(1, subject.occurred_count(start_time))
      assert_equal(1, subject.occurred_count(start_time+1.hour))
      assert_equal(0, subject.occurred_count(start_time - 1.hour))
      assert_equal(1, subject.occurred_count(start_time + 2.hour))
    end
    should "have next_occurring_time for one time event" do
      subject = @monday_1400
      start_time = subject.start_time
      period = subject.period

      assert_equal(start_time, subject.next_occurring_time(start_time))
      assert_equal(start_time, subject.next_occurring_time(start_time - 1.hour))
      assert_nil(subject.next_occurring_time(start_time+1.hour))
      assert_nil(subject.next_occurring_time(start_time + 2.hour))
    end
    should "have disjoint occurrence" do
      @test_occurrence = FactoryBot.build(:occurrence, duration: 3.hour, period: 1.hour)
      assert(!@test_occurrence.valid?)
      @test_occurrence = FactoryBot.build(:occurrence, duration: 3.hour, period: 3.hour)
      assert(@test_occurrence.valid?)
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
