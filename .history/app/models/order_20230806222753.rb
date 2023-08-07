class Order < ApplicationRecord
  belongs_to :user  
  has_one :cart
  has_many :order_items
  belongs_to :province, optional: true


  attr_accessor :modified_name, :modified_address, :modified_province_id

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "gst", "hst", "id", "province", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id", mail]
  end


  def calculate_taxes(user_province)
    # Get Province from user
    province = Province.find_by(id: user_province)

    # Tax Calculation
    if total_amount && province && province.gst_rate && province.pst_rate && province.hst_rate
      self.gst = total_amount * province.gst_rate
      self.pst = total_amount * province.pst_rate
      self.hst = total_amount * province.hst_rate

      # Total Taxes
      if province.hst_applicable
        self.total_amount_with_taxes = total_amount + hst
      else
        self.total_amount_with_taxes = total_amount + gst + pst
      end
    else
      # If not foud set to 0
      self.gst = 0
      self.pst = 0
      self.hst = 0
      self.total_amount_with_taxes = 0
    end
  end
end
