class CartItemsController < ApplicationController
    before_action :authenticate_user!, except: [:index]

    def index
        @cart_items = current_user.cart_items if user_signed_in?
    end
    
    def create
      @cart_item = current_user.cart_items.build(product_id: params[:product_id])
  
      if @cart_item.save
        flash[:success] = 'Product added to cart!'
        redirect_to cart_items_path
      else
        flash[:error] = 'Failed to add product to cart.'
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
