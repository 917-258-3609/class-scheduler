module ConstructionHelper
  module SubjectLevels 
    def create_subject_levels
      @regular_math = FactoryBot.create(:subject_level, subject: @math, level: 2, level_name: "Regular")  
      @advanced_math = FactoryBot.create(:subject_level, subject: @math, level: 1, level_name: "Advanced")  
      @olympiad_math = FactoryBot.create(:subject_level, subject: @math, level: 0, level_name: "Olympiad")
      @regular_english = FactoryBot.create(:subject_level, subject: @english, level: 1, level_name: "Regular")  
      @oxford_english = FactoryBot.create(:subject_level, subject: @english, level: 0, level_name: "Oxford")
      @nobel_science = FactoryBot.create(:subject_level, subject: @science, level: 0,level_name: "Nobel")
    end
    def destroy_subject_levels
      @regular_math.delete
      @advanced_math.delete
      @olympiad_math.delete
      @regular_english.delete
      @oxford_english.delete
      @nobel_science.delete
    end
  end
end