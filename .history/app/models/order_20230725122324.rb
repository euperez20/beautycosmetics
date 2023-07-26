class Order < ApplicationRecord
  belongs_to :user
  has_one :cart_item
  # belongs_to :cart
  # belongs_to :province
  has_many :order_items

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "gst", "hst", "id", "province", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id"]
  end


  def calculate_taxes(user_province)
    # Obtener la provincia del usuario
    province = Province.find_by(id: user_province)

    # Calcular los impuestos y el total de la orden
    if total_amount && province && province.gst_rate && province.pst_rate && province.hst_rate
      self.gst = total_amount * province.gst_rate
      self.pst = total_amount * province.pst_rate
      self.hst = total_amount * province.hst_rate

      # Calcular el total con impuestos
      if province.hst_applicable
        self.total_amount_with_taxes = total_amount + hst
      else
        self.total_amount_with_taxes = total_amount + gst + pst
      end
    else
      # Si no se encuentran los valores, los impuestos y el total serán cero
      self.gst = 0
      self.pst = 0
      self.hst = 0
      self.total_amount_with_taxes = 0
    end
  end
end
