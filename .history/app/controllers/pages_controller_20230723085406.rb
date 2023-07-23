# app/controllers/pages_controller.rb
class PagesController < ApplicationController
   
  
    def contact
      @categories = Category.all
      @contact_page = Page.find_by(title: 'Contact') 
    end
  
    def about
      @categories = Category.all
      @about_page = Page.find_by(title: 'About') 
    end

    def front
      # before_action :cart_count
      @categories = Category.all
      @featured_products = Product.where(featured: true).limit(3)
      ActiveStorage::Current.url_options = { host: request.base_url }
      @new_products = Product.where('created_at >= ?', 3.days.ago).limit(6)
      
      
    end
  end
  