class ChangeCategoryStringToReferenceInProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :category, :string
    add_reference :products, :category, foreign_key: true
  end
end
