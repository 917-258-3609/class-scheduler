class User < ApplicationRecord
    belongs_to :accountable, polymorphic: true, optional: true
    
    validates_presence_of :email
    validates_uniqueness_of :email, case_sensitive: false
    validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
    
    before_validation :sanitize
    def teacher
        accountable if accountable.is_a? Teacher
    end
    def student 
        accountable if accountable.is_a? Student
    end
    def pay(amount)
        self.balance += (amount*100)
        self.save
    end
    # TODO rename this
    def total_balance(time=Time.now)
        (self.balance - self.accountable.total_charge_on(time))/100.0
    end
    private
    def sanitize
        self.email.downcase!
    end
end
