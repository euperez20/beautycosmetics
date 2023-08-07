class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :set_active_storage_url_options, only: [:show_products]

  # GET /categories or /categories.json
  def index
    @categories = Category.all
    @categories = Category.page(params[:page]).per(10)
   
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


  


  def show_products
    @category = Category.find(params[:id])
    # @products = @category.products
    @products = @category.products.page(params[:page]).per(10)
  end

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

end
