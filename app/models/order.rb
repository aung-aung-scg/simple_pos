# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  status      :string           default("pending")
#  total_price :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  has_many :products, through: :order_items
  enum status: {
    pending: 'pending',
    processing: 'processing',
    shipped: 'shipped',
    completed: 'completed',
    cancelled: 'cancelled'
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  validates :status, inclusion: { in: %w[pending processing shipped completed cancelled] }
  def status_badge_class
    case status.to_s.downcase
    when 'pending', 'new'
      'bg-warning text-dark'
    when 'processing', 'in_progress'
      'bg-info text-white'
    when 'completed', 'shipped', 'delivered'
      'bg-success text-white'
    when 'cancelled', 'failed', 'declined'
      'bg-danger text-white'
    else
      'bg-secondary text-white'
    end
  end
end
