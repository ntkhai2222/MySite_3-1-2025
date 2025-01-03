class AddFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :menu_id, :integer
    add_column :products, :price, :string, default: 0
    add_column :products, :discount, :integer, default: 0
    add_column :products, :view, :integer, default: 0
    add_column :products, :slug, :string
  end
end
