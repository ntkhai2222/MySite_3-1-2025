class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy

  validates :name, :phone, :email, :shipping_name, :shipping_phone, :shipping_address, :shipping_date, :shipping_time, :status, presence: true

end
