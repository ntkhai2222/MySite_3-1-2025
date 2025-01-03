class CreateBanners < ActiveRecord::Migration[8.0]
  def change
    create_table :banners do |t|
      t.string :name
      t.integer :item
      t.boolean :active
      t.string :link
      t.string :slug

      t.timestamps
    end
  end
end
