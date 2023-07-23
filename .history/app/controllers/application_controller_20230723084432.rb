class ApplicationController < ActionController::Base
    before_action :cart_count
    # def after_sign_in_path_for(resource)
    #     root_path
    #   end
end
