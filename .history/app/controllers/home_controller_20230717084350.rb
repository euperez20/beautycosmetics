class HomeController < ApplicationController
  def index
    @featured_products = Product.where(category: true)
  end
end
