class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :set_active_storage_url_options, only: [:show_products]
  before_action :set_category, only: [:show, :show_products]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
    @categories = Category.page(params[:page]).per(10)
    @category = Category.first
   
  end

  # GET /categories/1 or /categories/1.json
  def show
    @category = Category.find(params[:id])
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # Update
  
  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Categoría actualizada exitosamente."
    else
      render :edit
    end
  end


  
  def search
    category_id = params[:category_id]
    search_term = params[:search]
  
    @categories = Category.all
    @category = Category.find_by(id: category_id) if category_id.present?
  
    if @category.present? && search_term.present?
      @products = @category.products.where("name LIKE ?", "%#{search_term}%")
    elsif @category.present?
      @products = @category.products
    elsif search_term.present?
      @products = Product.where("name LIKE ?", "%#{search_term}%")
    else
      @products = Product.all
    end
  end
  


  def show
    
    if params[:category_id].present?
      @category = Category.find_by(id: params[:category_id])
      if @category.present? && params[:search].present?
        @products = @category.products.where("name LIKE ?", "%#{params[:search]}%")
      else
        @products = @category.products
      end
    else
      @products = Product.where("name LIKE ?", "%#{params[:search]}%")
    end
  end


  def show_products
    
NoMethodError in Categories#show_products

Showing /mnt/c/fullstack/Projects/ecommerce/coding/beautycosmetics/app/views/shared/_header.html.erb where line #104 raised:

undefined method `each' for nil:NilClass

'.freeze;     @categories.each do |category| 
                         ^^^^^

Extracted source (around line #104):

102
103
104
105
106
107
              

	

  <select name="category_id" class="form-select me-2" aria-label="Select Category">
    <option value="">All Categories</option>
    <% @categories.each do |category| %>
      <option value="<%= category.id %>"><%= category.name %></option>
    <% end %>
  </select>


    @categories = Category.find(params[:id])
    @products = @category.products
    @categories = Category.all
  end

  # def show_products
  #   @category = Category.find(params[:id])
  #   @products = @category.products

  #   if params[:search].present?
  #     @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
  #   end
  # end

  # Show products by category
  # def show_products
  #   @category = Category.find_by(id: params[:id])
  #   if @category.nil?
  #     flash[:alert] = "Category not found "
  #     redirect_to root_path
  #   else
  #     @products = @category.products
  #   end
  # end

  def set_category
    @category = Category.find(params[:id])
  end

  # DELETE 
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end

  

  end

  private

    def category_params
      params.require(:category).permit(:name, :other_attribute) # Asegúrate de agregar aquí todos los atributos permitidos para actualizar.
    end

    def set_active_storage_url_options
      ActiveStorage::Current.host = request.base_url
    end

    
    def set_category      
      @category = nil if params[:category_id].present?
    end

end
