module ConstructionHelper
  module Students
    def create_students
      @lucifer_lombardi = FactoryBot.create(:student, first_name: "Lucifer", last_name: "Lombardi")
      @dave_gurney = FactoryBot.create(:student, first_name: "Dave", last_name: "Gurney")
      @mark_perry = FactoryBot.create(:student, first_name: "Mark", last_name: "Perry")
      @sha_chia = FactoryBot.create(:student, first_name: "Sha", last_name: "Chia")
      @little_ming = FactoryBot.create(:student, first_name: "Little", last_name: "Ming")
    end
    def destroy_students
      @lucifer_lombardi.destroy
      @dave_gurney.destroy
      @mark_perry.destroy
      @sha_chia.destroy
      @little_ming.destroy
    end
  end
end