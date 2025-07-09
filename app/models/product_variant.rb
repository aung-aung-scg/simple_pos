class ProductVariant < ApplicationRecord
  belongs_to :product
  has_one_attached :image

  validates :color, :size, presence: true

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize_to_limit: [300, 300]).processed, only_path: true) : ''
  end
end
