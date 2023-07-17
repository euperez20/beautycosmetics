class HomeController < ApplicationController
  def index
    @featured_products = Product.where(brand: true)
  end
end
