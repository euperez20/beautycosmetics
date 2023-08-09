class ApplicationController < ActionController::Base
   
    protect_from_forgery with: :exception
    before_action :set_cart_count
    before_action :set_categories
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    # def home
    #     @categories = Category.all    
    # end

    private

    def set_cart_count
        if user_signed_in?
          @cart_count = current_user.cart_items.count
        else
          @cart_count = session[:cart_items].sum { |item| item['quantity'] }
        end
        puts "Cart Count: #{@cart_count}"
    end

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :province_id])
    end

    def set_categories
        @categories = Category.all
    end

end
