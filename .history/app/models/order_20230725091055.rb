class Order < ApplicationRecord
  belongs_to :user
  has_one :cart
  # belongs_to :cart
  # belongs_to :province
  has_many :order_items
end
