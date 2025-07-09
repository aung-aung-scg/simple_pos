# == Schema Information
#
# Table name: product_variants
#
#  id         :integer          not null, primary key
#  color      :string
#  size       :string
#  stock      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :integer          not null
#
# Indexes
#
#  index_product_variants_on_product_id  (product_id)
#
# Foreign Keys
#
#  product_id  (product_id => products.id)
#
require "test_helper"

class ProductVariantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
