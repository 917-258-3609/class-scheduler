require "test_helper"

class OccurrenceTest < ActiveSupport::TestCase
  context "occurrences" do
    setup do
      @o1 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-01 09:00:00"
      )
      @o2 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-01 09:00:00"
      )
      @o3 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 09:00:00",
        end_time_s: "2022-08-01 10:00:00"
      )
      @o4 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 08:30:00",
        end_time_s: "2022-08-01 09:30:00"
      )
      @o5 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-01 08:01:00"
      )
      @o6 = FactoryBot.create(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-01 10:00:00"
      )
    end
    should "have overlapping? method to check if two occurrences overlap each other" do
      assert_overlapping(@o1, @o2)
      assert_not_overlapping(@o1, @o3)
      assert_overlapping(@o1, @o4)
      assert_overlapping(@o1, @o5)
      assert_overlapping(@o1, @o6)
      assert_overlapping(@o3, @o4)
      assert_not_overlapping(@o3, @o5)
      assert_overlapping(@o3, @o6)
      assert_not_overlapping(@o4, @o5)
      assert_overlapping(@o4, @o6)
      assert_overlapping(@o5, @o6)
    end
    should "have occurs_on? method to check if occurrence is occuring at given time" do
      assert(!@o5.occurs_on?(Time.parse "2022-08-01 07:59:59 UTC"))
      assert(@o5.occurs_on?(Time.parse "2022-08-01 08:00:00 UTC"))
      assert(@o5.occurs_on?(Time.parse "2022-08-01 08:00:01 UTC"))
      assert(@o5.occurs_on?(Time.parse "2022-08-01 08:00:59 UTC"))
      assert(!@o5.occurs_on?(Time.parse "2022-08-01 08:01:00 UTC"))
      assert(!@o5.occurs_on?(Time.parse "2022-08-01 08:01:01 UTC"))
    end
    should "have start_time before end_time" do
      bad_occurrence = FactoryBot.build(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-01 07:00:00"
      )
      assert(!bad_occurrence.valid?)
    end
    should "have duration shorter than a day" do
      bad_occurrence = FactoryBot.build(:occurrence, 
        start_time_s: "2022-08-01 08:00:00",
        end_time_s: "2022-08-02 09:00:00"
      )
      assert(!bad_occurrence.valid?)
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
