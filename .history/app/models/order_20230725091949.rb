class Order < ApplicationRecord
  belongs_to :user
  has_one :cart
  # belongs_to :cart
  # belongs_to :province
  has_many :order_items


  def calculate_taxes(user_province)
    province = Province.find_by(id: user_province)

    if province
      self.gst = total_amount * province.gst_rate
      self.pst = total_amount * province.pst_rate
      self.total_amount_with_taxes = total_amount + gst + pst
    else
      # Si no se encuentra la provincia, los impuestos serán cero
      self.gst = 0
      self.pst = 0
      self.total_amount_with_taxes = total_amount
    end
  end
end
