# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_categories_on_parent_id  (parent_id)
#
class Category < ApplicationRecord
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true

  has_many :products
  validates :name, presence: true
  scope :main_categories, -> { where(parent_id: nil) }
  scope :subcategories, -> { where.not(parent_id: nil) }

  def all_products
    Product.where(category_id: [id] + subcategories.pluck(:id))
  end

  def deletable?
    all_products.none?
  end
end
