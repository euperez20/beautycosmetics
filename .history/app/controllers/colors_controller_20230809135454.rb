class ColorsController < ApplicationController
  before_action :set_color, only: %i[ show edit update destroy ]

  def index
    @colors = Color.all
    @categories = Category.all
  end

  def show
  end

  def new
    @color = Color.new
  end
 
  def edit
  end

  def create
    @color = Color.new(color_params)

    respond_to do |format|
      if @color.save
        format.html { redirect_to color_url(@color), notice: "Color was successfully created." }
        format.json { render :show, status: :created, location: @color }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @color.update(color_params)
        format.html { redirect_to color_url(@color), notice: "Color was successfully updated." }
        format.json { render :show, status: :ok, location: @color }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @color.destroy

    respond_to do |format|
      format.html { redirect_to colors_url, notice: "Color was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_color
      @color = Color.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def color_params
      params.require(:color).permit(:hex_value, :color_name)
    end
end
