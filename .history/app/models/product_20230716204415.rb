class Product < ApplicationRecord
  belongs_to :category
  has_many :product_colors
  has_many :colors, through: :product_colors

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "image", "name", "price", "updated_at"]
  end
end
