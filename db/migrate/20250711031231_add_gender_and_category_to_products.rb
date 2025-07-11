class AddGenderAndCategoryToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :gender, :string
    add_column :products, :category, :string
  end
end
