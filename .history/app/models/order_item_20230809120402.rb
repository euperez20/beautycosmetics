class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

    validates :order, presence: true
  validates :product, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "order_id", "updated_at", "product_id", "quantity", "price"] 
  end

  ransack_alias :quantity_eq, :quantity_virtual_column

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

end
