class Devise::RegistrationsController < DeviseController
    before_action :configure_sign_up_params, only: [:create]
  
    def home
      @categories = Category.all    
    end
  
    protected
  
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :province_id])
    end  
  
  end
  