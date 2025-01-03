class Page < ApplicationRecord
  has_rich_text :description
  validates :name, presence: true
  before_save :generate_slug

  private

  def generate_slug
    self.slug = name.to_slug.normalize.to_s
  end
end
