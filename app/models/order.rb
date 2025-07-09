# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
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
end
