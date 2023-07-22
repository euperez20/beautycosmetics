class Product < ApplicationRecord
  belongs_to :category
  has_many :product_colors
  has_many :colors, through: :product_colors
  # has_one_attached :image

  validates :image, attached: false, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'], size: { less_than: 5.megabytes }, url: true
  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "image", "name", "price", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["category", "colors", "product_colors"]
  end
end
