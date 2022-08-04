class User < ApplicationRecord
    belongs_to :accountable, polymorphic: true
    
    validates_presence_of :email
    validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
