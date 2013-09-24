class User < ActiveRecord::Base
  has_many :recipes

  before_save { self.email.downcase! }

  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false })

  has_secure_password
  validates(:password, length: { minimum: 6 })

end
