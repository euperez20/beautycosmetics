class Order < ApplicationRecord
  belongs_to :user
  has_one :cart
  # belongs_to :cart
  # belongs_to :province
  has_many :order_items


  def calculate_taxes(user_province)
    # Obtener la provincia del usuario
    province = Province.find_by(id: user_province)

    if province
      # Calcular los impuestos basados en los porcentajes de la provincia
      self.gst = total_amount * province.gst_rate
      self.pst = total_amount * province.pst_rate
      self.hst = total_amount * province.hst_rate

      # Calcular el total con impuestos
      if province.hst_applicable
        self.total_amount += hst
      else
        self.total_amount += gst + pst
      end
    else
      # Si no se encuentra la provincia, los impuestos serán cero
      self.gst = 0
      self.pst = 0
      self.hst = 0
    end
  end
end
