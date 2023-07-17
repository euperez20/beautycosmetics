class Color < ApplicationRecord
    has_many :product_colors
    has_many :products, through: :product_colors
    
    def self.ransackable_associations(auth_object = nil)
        ["product_colors", "products"]
    end
end
