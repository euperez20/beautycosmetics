class Product < ApplicationRecord
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "image", "name", "price", "updated_at"]
  end
end
