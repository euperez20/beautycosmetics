class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :cart_count
  
  def product_params
    params.require(:product).permit(:name, :description, :price, :brand, :image)
  end

  # GET /products or /products.json
  def index
    # @products = Product.all
    # @categories = Category.all
    # @products = Product.page(params[:page]).per(10)
    # @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    # @products = @products.where('name LIKE ?', "%#{params[:search]}%") if params[:search].present?

    @categories = Category.all

  if params[:category_id].present?
    @category = Category.find_by(id: params[:category_id])
    @products = @category.products if @category.present?
  else
    @products = Product.all
  end

  # Paginar la colección de productos
  @products = @products.paginate(page: params[:page], per_page: 12)
   
    end
    

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
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

  # PATCH/PUT /products/1 or /products/1.json
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

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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


end
