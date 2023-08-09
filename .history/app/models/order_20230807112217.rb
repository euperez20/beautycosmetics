class Order < ApplicationRecord
  belongs_to :user, optional: true 
  # has_one :cart
  has_many :order_items
  belongs_to :province, optional: true


  # attr_accessor :modified_name, :modified_address, :modified_province_id

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "gst", "hst", "id", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id", "email", "order_items", "province", "user"]
  end


end
