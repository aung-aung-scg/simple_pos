# == Schema Information
#
# Table name: order_items
#
#  id                 :integer          not null, primary key
#  quantity           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer          not null
#  product_id         :integer          not null
#  product_variant_id :integer          not null
#
# Indexes
#
#  index_order_items_on_order_id            (order_id)
#  index_order_items_on_product_id          (product_id)
#  index_order_items_on_product_variant_id  (product_variant_id)
#
# Foreign Keys
#
#  order_id            (order_id => orders.id)
#  product_id          (product_id => products.id)
#  product_variant_id  (product_variant_id => product_variants.id)
#
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :product_variant
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
end
