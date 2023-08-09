class CartItem < ApplicationRecord
  belongs_to :product
  # belongs_to :user
 

  # def self.ransackable_associations(auth_object = nil)
  #   super + ['cart_item']
  # end

end
