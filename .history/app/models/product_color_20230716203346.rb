class ProductColor < ApplicationRecord
  belongs_to :product
  belongs_to :color

  def self.ransackable_attributes(auth_object = nil)
    ["product_id", "color_id", "created_at", "id", "updated_at"]
  end

  
end
