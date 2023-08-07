class HomeController < ApplicationController
  def index
    @welcome_message = "Welcome"
    @categories = Category.all
  end
end
