class Color < ApplicationRecord
    has_many :product_colors
  has_many :products, through: :product_colors
    def self.ransackable_attributes(auth_object = nil)
        ["color_name", "created_at", "hex_value", "id", "updated_at"]
    end
end
