class User < ActiveRecord::Base
before_save {self.email = email.downcase }
    validates :email , presence: true,
                        format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                        uniqueness: {case_sensitive: false}
    validates :password ,presence: true,
                        length: {minimum:8},
                        uniqueness: true
end
