class ApplicationController < ActionController::Base
   
    protect_from_forgery with: :exception
    before_action :set_cart_count

    # private

    def set_cart_count
        @cart_count = current_user.cart_items.count if user_signed_in?
    end

end
