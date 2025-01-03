class Banner < ApplicationRecord
  has_one_attached :featured_image
  before_save :generate_slug

  private

  def generate_slug
    self.slug = name.to_slug.normalize.to_s
  end
end
