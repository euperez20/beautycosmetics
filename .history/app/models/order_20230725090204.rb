class Order < ApplicationRecord
  belongs_to :user
  belongs_to :cart
  # belongs_to :province
  has_many :order_items, dependent: :destroy
end
