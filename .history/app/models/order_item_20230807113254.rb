class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # t.decimal :price, precision: 10, scale: 2

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "order_id", "updated_at", "product_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

end
