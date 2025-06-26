class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Enum for user roles
  enum role: { user: 'user', admin: 'admin' }

  # Default role for new users
  after_initialize :set_default_role, if: :new_record?

  def encrypted_password=(new_password)
    self.password = new_password if new_password.present?
  end

  def encrypted_password
    password_digest
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
