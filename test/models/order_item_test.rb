# == Schema Information
#
# Table name: order_items
#
#  id                 :integer          not null, primary key
#  quantity           :integer
#  unit_price         :decimal(, )
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
require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
