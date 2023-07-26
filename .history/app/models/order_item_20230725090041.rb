class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  t.decimal :price, precision: 10, scale: 2
end
