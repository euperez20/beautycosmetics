class CartItemsController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    

    def index
        @cart_items = current_user.cart_items if user_signed_in?
    end
    
    def create
      product_id = params[:product_id]
  quantity = params[:quantity].to_i

  cart = session[:cart] || {}
  cart[product_id] = (cart[product_id] || 0) + quantity

  session[:cart] = cart

  redirect_to products_path, notice: 'Product added to cart!'
    end
    
      def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        redirect_to cart_path, notice: 'Product removed from cart.'
      end

      def cart_count
        @cart_count = current_user.cart_items.sum(:quantity) if user_signed_in?
      end

      def update
        @cart_item = CartItem.find(params[:id])
        if @cart_item.update(cart_item_params)
          redirect_to cart_items_path, notice: 'Item updated successfully.'
        else
          render :index
        end
      end
      
      private
      
      def cart_item_params
        params.require(:cart_item).permit(:quantity)
      end


end
