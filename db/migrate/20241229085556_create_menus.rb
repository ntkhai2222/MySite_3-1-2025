class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :menu_fk
      t.string :slug

      t.timestamps
    end
  end
end
