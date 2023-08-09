class Order < ApplicationRecord
  enum status: { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }
  belongs_to :user, optional: true
  has_many :order_items
  belongs_to :province, optional: true

  # validates :status, presence: true
  # validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates :gst, :pst, :hst, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :taxes_required?
  validates :address, presence: true
  validates :address, presence: true
  

  def self.ransackable_attributes(auth_object = nil)
    super + ["address", "created_at", "gst", "hst", "id", "province", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id", "email"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "province", "user"]
  end
end
