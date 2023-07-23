class CartItemsController < ApplicationController
    before_action :authenticate_user!, except: [:index]

    def index
        @cart_items = current_user.cart_items if user_signed_in?
    end
    
    def create
        product = Product.find(params[:product_id])
        @cart_item = current_user.cart_items.build(product: product)
    
        if @cart_item.save
          redirect_to cart_path, notice: 'Product added to cart.'
        else
          redirect_to product, alert: 'Unable to add product to cart.'
        end
    end
    
      def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        redirect_to cart_path, notice: 'Product removed from cart.'
      end


end
