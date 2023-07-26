class Order < ApplicationRecord
  before_action :authenticate_user!

  belongs_to :user
  belongs_to :cart
  # belongs_to :province
  has_many :order_items
end
