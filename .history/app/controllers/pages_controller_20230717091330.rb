# app/controllers/pages_controller.rb
class PagesController < ApplicationController
    def contact
      @contact_page = Page.find_by(title: 'Contact') # O el título que hayas usado en la tabla
    end
  
    def about
      @about_page = Page.find_by(title: 'About') # O el título que hayas usado en la tabla
    end
  end
  