class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # t.decimal :price, precision: 10, scale: 2

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "province", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id", "email"]
  end

end
