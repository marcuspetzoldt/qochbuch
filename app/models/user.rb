class User < ActiveRecord::Base
  has_many :recipes
  has_many :votes

  before_save { self.email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  # An account is deemed dead if no recipes were created, and the account is older than 3 months
  def dead_account?
    recipes.count == 0 && (Time.now - created_at) > 3.months
  end

end
