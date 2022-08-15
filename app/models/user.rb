class User < ApplicationRecord
    belongs_to :accountable, polymorphic: true, optional: true
    
    validates_presence_of :email
    validates_uniqueness_of :email, case_sensitive: false
    validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
    
    def teacher
        accountable if accountable.is_a? Teacher
    end
    def student 
        accountable if accountable.is_a? Student
    end
end
