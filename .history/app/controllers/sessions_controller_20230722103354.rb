# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
    # DELETE /users/sign_out
    def destroy
      super # Este método ya se encarga de hacer logout y redireccionar al root_path
    end
  
    protected
  
    def after_sign_out_path_for(resource_or_scope)
      products_path # Redirige al root_path después del logout
    end
  end
  