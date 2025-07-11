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
class Product < ApplicationRecord
  has_many :order_items
  has_one_attached :image
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :gender, inclusion: { in: %w[men women kid], allow_blank: true }
  belongs_to :category, optional: true
end
