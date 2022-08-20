require "test_helper"

class SubjectLevelTest < ActiveSupport::TestCase
  context "subject_levels" do
    setup do
      create_subjects
      create_subject_levels
    end
    # teardown do
    #   destroy_subject_levels
    # end
    should "create and destroy subject_levels" do
    end
  end
end
