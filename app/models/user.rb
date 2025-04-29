class User < ApplicationRecord
  has_secure_password

  enum role: { user: "user", admin: "admin" }

  def admin?
    admin == true
  end
end
