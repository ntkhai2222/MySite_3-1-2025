class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :shipping_name
      t.string :shipping_phone
      t.string :shipping_address
      t.datetime :shipping_date
      t.string :shipping_time
      t.string :shipping_mess
      t.string :shipping_note
      t.string :discount
      t.string :order_total
      t.string :status

      t.timestamps
    end
  end
end
