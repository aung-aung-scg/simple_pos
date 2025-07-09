class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Enum for user roles
  enum role: { user: 'user', admin: 'admin' }

  # Default role for new users
  after_initialize :set_default_role, if: :new_record?
  has_many :orders, dependent: :destroy

  private

  def set_default_role
    self.role ||= :user
  end
end
