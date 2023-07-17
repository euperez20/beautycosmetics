class HomeController < ApplicationController
  def index
    @featured_products = Product.where(category_name: true)
  end
end
