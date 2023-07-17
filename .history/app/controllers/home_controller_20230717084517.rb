class HomeController < ApplicationController
  def index
    @featured_products = Product.where(Brand: true)
  end
end
