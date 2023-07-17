class HomeController < ApplicationController
  def index
    @featured_products = Product.where(featured: true)
  end
end
