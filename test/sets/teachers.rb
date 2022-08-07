module ConstructionHelper
  module Teachers
    def create_teachers
      @peach = FactoryBot.create(:teacher)
      @peach.subject_levels << @regular_math
      @peach.subject_levels << @regular_english
      @peach.subject_levels << @nobel_science

      @apple = FactoryBot.create(:teacher, name: "Apple")
      @apple.subject_levels << @advanced_math
      @apple.subject_levels << @regular_english

      @melon = FactoryBot.create(:teacher, name: "Melon")
      @melon.subject_levels << @olympiad_math

      @strawberry = FactoryBot.create(:teacher, name: "Strawberry")
      @strawberry.subject_levels << @nobel_science
    end
    def destroy_teachers
      @peach.delete
      @apple.delete
      @melon.delete
      @strawberry.delete
    end
  end
end