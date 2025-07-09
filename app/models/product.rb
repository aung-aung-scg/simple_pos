class Product < ApplicationRecord
  has_many :order_items
  has_one_attached :image
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true
end
