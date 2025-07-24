# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  archived    :boolean          default(FALSE)
#  archived_at :datetime
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
#  index_products_on_archived     (archived)
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
class Product < ApplicationRecord
  # Associations
  has_many :order_items, dependent: :restrict_with_error
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
  validate :stock_consistency
  validate :validate_image_type
  validate :validate_image_size

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

  def can_be_deleted?
    order_items.none?
  end

  private

  def validate_image_type
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/jpg])
      errors.add(:image, 'must be a JPEG or PNG image')
      image.purge
    end
  end

  def validate_image_size
    return unless image.attached?

    if image.byte_size > 5.megabytes
      errors.add(:image, 'should be less than 5MB')
      image.purge # Remove the invalid attachment
    end
  end

  def stock_consistency
    if product_variants.any? && stock.positive?
      errors.add(:base, "Stock should be managed at variant level for products with variants")
    end
  end
end
