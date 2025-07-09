class CreateProductVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :color
      t.string :size
      t.integer :stock

      t.timestamps
    end
  end
end
