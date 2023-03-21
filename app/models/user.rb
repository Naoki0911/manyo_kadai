class User < ApplicationRecord
  before_destroy :admin_user_null
  before_update :admin_user_null
  before_validation { email.downcase! }
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, length: { minimum: 6 }

  private

  def admin_user_null
    @user = User.all
    @user1 = User.find(id)
    throw(:abort) if @user.where(admin: true).count == 1 && @user1.admin == true
  end
end
