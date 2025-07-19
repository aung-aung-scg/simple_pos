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
  # Associations
  has_many :order_items, dependent: :nullify
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [300, 300]
    attachable.variant :medium, resize_to_limit: [600, 600]
  end
  has_many :product_variants, dependent: :destroy
  accepts_nested_attributes_for :product_variants, allow_destroy: true
  belongs_to :category, optional: true


  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true,
                   numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 0
                  }, if: -> { product_variants.empty? }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :gender, inclusion: { in: %w[men women kid],
                        message: "%{value} is not a valid gender" },
                     allow_blank: true
  validate :acceptable_image
  validate :stock_consistency

  # Scopes
  scope :in_stock, -> { where(stock: 1..) }
  scope :out_of_stock, -> { where(stock: 0) }
  scope :by_gender, ->(gender) { where(gender: gender) if gender.present? }

  # Methods
  def total_stock
    product_variants.any? ? product_variants.sum(:stock) : stock
  end

  def main_image
    image.attached? ? image : product_variants.first&.image
  end

  private

  def acceptable_image
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png])
      errors.add(:image, 'must be a JPEG or PNG')
    end

    if image.byte_size > 5.megabytes
      errors.add(:image, 'is too large (max 5MB)')
    end
  end

  def stock_consistency
    if product_variants.any? && stock.positive?
      errors.add(:base, "Stock should be managed at variant level for products with variants")
    end
  end
end
