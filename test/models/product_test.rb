# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  description :text
#  gender      :string
#  name        :string
#  price       :decimal(, )
#  stock       :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer
#
# Indexes
#
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
