class OrderDetail < ApplicationRecord
  has_one_attached :featured_image
  belongs_to :order

  validates :name, :quantity, :price, presence: true
end
