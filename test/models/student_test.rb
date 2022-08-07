require "test_helper"

class StudentTest < ActiveSupport::TestCase
  context "students" do
    setup do
      create_students
    end
    should "create and destroy students" do
    end
  end
end
