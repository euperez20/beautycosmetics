class CartItemsController < ApplicationController
    before_action :authenticate_user!, except: [:index]

    def index
        @cart_items = current_user.cart_items if user_signed_in?
    end
    
    def create
      product_id = params[:product_id].to_i
      @cart_item = current_user.cart_items.find_by(product_id: product_id)
  
      if @cart_item
        @cart_item.quantity += 1
      else
        @cart_item = current_user.cart_items.new(product_id: product_id, quantity: 1)
      end
  
      if @cart_item.save
        redirect_back(fallback_location: root_path, notice: 'Item added to cart!')
      else
        flash[:alert] = 'Unable to add item to cart.'
        redirect_back(fallback_location: root_path)
      end
    end
    
      def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        redirect_to cart_path, notice: 'Product removed from cart.'
      end

      def cart_count
        @cart_count = current_user.cart_items.sum(:quantity) if user_signed_in?
      end


end
