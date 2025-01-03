class Menu < ApplicationRecord
  belongs_to :parent, class_name: 'Menu', foreign_key: 'menu_fk', optional: true
  has_many :children, class_name: 'Menu', foreign_key: 'menu_fk', dependent: :destroy
  has_many :products, dependent: :destroy
  before_save :generate_slug

  private

  def generate_slug
    self.slug = name.to_slug.normalize.to_s
  end
end
