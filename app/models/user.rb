# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  address                :text
#  admin                  :boolean
#  email                  :string
#  encrypted_password     :string           default("")
#  name                   :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # Enum for user roles
  enum role: { user: 'user', admin: 'admin' }

  # Default role for new users
  after_initialize :set_default_role, if: :new_record?
  has_many :orders, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { maximum: 100 }
  validates :phone, presence: true
  validates :address, presence: true, length: { maximum: 500 }
  before_validation :normalize_phone_number
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  has_one_attached :profile_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
    attachable.variant :medium, resize_to_limit: [600, 600]
  end
  validate :acceptable_profile_image

  def formatted_phone
    phone.gsub(/(\d{2})(\d{3})(\d{4})/, '\1-\2-\3') if phone.present?
  end

  def deletable?
    id != 1 && !admin?
  end

  private

  def set_default_role
    self.role ||= :user
  end

  def normalize_phone_number
    self.phone = phone.gsub(/[^\d]/, '') if phone.present?
  end

    def acceptable_profile_image
    return unless profile_image.attached?

    unless profile_image.content_type.in?(%w[image/jpeg image/png])
      errors.add(:profile_image, 'must be a JPEG or PNG')
    end

    if profile_image.byte_size > 5.megabytes
      errors.add(:profile_image, 'is too large (max 5MB)')
    end
  end
end
