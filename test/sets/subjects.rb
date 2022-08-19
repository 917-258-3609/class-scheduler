module ConstructionHelper
  module Subjects 
    def create_subjects
        @math = FactoryBot.create(:subject, name: "Math")
        @english = FactoryBot.create(:subject, name: "English")
        @science = FactoryBot.create(:subject, name: "Science")
    end
    def destroy_subjects
        @math.destroy
        @english.destroy
        @science.destroy
    end
  end
end