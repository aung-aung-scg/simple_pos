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
class ProductVariant < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  validates :color, :size, presence: true

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize_to_limit: [300, 300]).processed, only_path: true) : ''
  end
end
