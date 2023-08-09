class ApplicationController < ActionController::Base
   
    protect_from_forgery with: :exception
    before_action :set_cart_count
    before_action :configure_permitted_parameters, if: :devise_controller?
    # before_action :set_categories


    def home
        # @categories = Category.all    
    end

    private

    def set_cart_count
        @cart_count = current_user.cart_items.count if user_signed_in?
        puts "Cart Count: #{@cart_count}"
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :province_id])
    end

    # def set_categories
    #     @categories = Category.all
    # end

end
