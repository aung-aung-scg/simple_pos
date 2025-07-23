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
  validate :prevent_circular_references
  scope :main_categories, -> { where(parent_id: nil) }
  scope :subcategories, -> { where.not(parent_id: nil) }

  private

  def prevent_circular_references
    if parent_id == id
      errors.add(:parent_id, "cannot be itself")
    end
  end
end
