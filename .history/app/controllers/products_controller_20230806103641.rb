class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :cart_count
  before_action :load_categories, only: [:search, :index, :show]
  
  def product_params
    params.require(:product).permit(:name, :description, :price, :brand, :image)
  end

 
  def index
    @categories = Category.all
    @products = Product.all

    if params[:category_id].present?
      @selected_category = Category.find_by(id: params[:category_id])
      @products = @selected_category.products
    end

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @products = @products.where("name LIKE ? OR brand LIKE ?", search_term, search_term)
    end

    # Kaminary Pagination
    @products = @products.page(params[:page]).per(12)
    
    @products_array = @products.to_a

  end
   
  #Show
  def show
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  # New
  def new
    @product = Product.new
  end

  # Edit
  def edit
  end

  # POST
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    category_id = params[:category_id]
    search_term = params[:search]

    @categories = Category.all
    @category = Category.find_by(id: category_id) if category_id.present?

    if @category.present? && search_term.present?
      @search_results = @category.products.where("name LIKE ?", "%#{search_term}%").page(params[:page]).per(10)
    elsif @category.present?
      @search_results = @category.products.page(params[:page]).per(10)
    elsif search_term.present?
      @search_results = Product.where("name LIKE ?", "%#{search_term}%").page(params[:page]).per(10)
    else
      @search_results = Product.all.page(params[:page]).per(10)
    end
  end
end


  # DELETE 
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :brand, :image, :category_id)
    end

    def cart_count
      @cart_count = current_user.cart_items.sum(:quantity) if user_signed_in?
    end

    def load_categories
      @categories = Category.all
    end


end
