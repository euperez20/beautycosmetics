class Order < ApplicationRecord
  enum status: { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }
  belongs_to :user, optional: true 
  # has_one :cart
  has_many :order_items
  belongs_to :province, optional: true


  # attr_accessor :modified_name, :modified_address, :modified_province_id


  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "gst", "hst", "id", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id", "email", "order_items", "province_id", "product_id", "name"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id email]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "province", "user"]
  end


end
