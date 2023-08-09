class CartItem < ApplicationRecord

  def self.ransackable_associations(auth_object = nil)
    super + ['cart_item']
  end

end
