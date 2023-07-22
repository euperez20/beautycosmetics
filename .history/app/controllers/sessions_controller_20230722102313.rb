class Users::SessionsController < Devise::SessionsController
    # Sobrescribe el método after_sign_in_path_for
    def after_sign_in_path_for(resource)
      # Aquí puedes cambiar la URL de redirección como desees.
      # Por ejemplo, para redirigir al usuario a la página de productos:
      products_path
    end

    protected

    def after_sign_out_path_for(resource_or_scope)
      products_path # Redirige al front (o a la página que desees) después del logout
    end


  end
  