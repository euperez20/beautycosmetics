class ProductColor < ApplicationRecord
  belongs_to :product
  belongs_to :color

  validates :product_id, :color_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["product_id", "color_id", "created_at", "id", "updated_at"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["product_id", "color_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["color", "product"]
  end
end
