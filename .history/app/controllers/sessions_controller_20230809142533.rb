class Users::SessionsController < Devise::SessionsController
    
    def home
      @categories = Category.all
     
    end

    def destroy
      super 
    end
  
    protected
  
    def after_sign_out_path_for(resource_or_scope)
      products_path 
    end
  end
  