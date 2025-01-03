class CreateOrderDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.string :name
      t.integer :quantity
      t.string :price

      t.timestamps
    end
  end
end
