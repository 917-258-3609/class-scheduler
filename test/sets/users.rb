module ConstructionHelper
  module Users 
    def create_users
      @default_teacher_user = FactoryBot.create(:user, :for_teacher)
      @inactive_student_user = FactoryBot.create(:user, :for_student, is_active: false)
      @rich_student_user = FactoryBot.create(:user, :for_student, balance: 10000)
    end 
    def destroy_users
      @default_teacher_user.delete
      @inactive_student_user.delete
      @rich_student_user.delete
    end
  end
end