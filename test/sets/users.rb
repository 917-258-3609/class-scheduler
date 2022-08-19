module ConstructionHelper
  module Users 
    def create_users
      @default_user = FactoryBot.create(:user, 
                                                email: "defaultno@gmail.com")
      @inactive_user = FactoryBot.create(:user, 
                                                 email: "inactive@gmail.com", 
                                                 is_active: false)
      @rich_user = FactoryBot.create(:user, 
                                             email: "rich@gmail.com", 
                                             balance: 10000)
    end 
    def destroy_users
      @default_teacher_user.delete
      @inactive_student_user.delete
      @rich_student_user.delete
    end
  end
end