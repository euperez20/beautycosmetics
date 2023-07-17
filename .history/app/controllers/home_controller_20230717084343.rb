class HomeController < ApplicationController
  def index
    @featured_products = Product.where(: true)
  end
end
