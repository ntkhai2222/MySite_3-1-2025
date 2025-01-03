class Product < ApplicationRecord
    include Notifications
    has_rich_text :description
    validates :name, presence: true
    has_one_attached :featured_image
    validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
    has_many :subscribers, dependent: :nullify
    belongs_to :menu, foreign_key: 'menu_id'
    has_many :carts
    has_many :users, through: :carts

    after_update_commit :notify_subscribers, if: :back_in_stock?
    
    before_save :generate_slug

    def back_in_stock?
      inventory_count_previously_was.zero? && inventory_count > 0
    end

    def notify_subscribers
      subscribers.each do |subscriber|
        ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
      end
    end
    private

    def generate_slug
      self.slug = name.to_slug.normalize.to_s
    end
end
