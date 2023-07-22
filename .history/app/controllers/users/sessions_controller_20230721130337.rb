# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: [:create]
  
    # POST /resource/sign_in
    def create
      # Find the user by email
      user = User.find_by(email: params[:user][:email])
  
      # Check if the user exists and if the password matches
      if user && user.valid_password?(params[:user][:password])
        sign_in(user) # Sign in the user using Devise helper method
        redirect_to root_path, notice: 'Successfully signed in!'
      else
        flash.now[:alert] = 'Invalid email or password'
        render :new
      end
    end
  
    protected
  
    # If you have extra sign in params, permit them here
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end
  end
  