class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    # Obtener el carrito del usuario actual
    cart = current_user.cart_items

    # Crear una nueva orden asociada al usuario
    order = current_user.orders.build

    # Agregar cada elemento del carrito como un ítem de la orden
    cart.each do |cart_item|
      order.order_items.build(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
    end

    # Calcular los impuestos y el total de la orden
    order.calculate_taxes

    # Guardar la orden en la base de datos
    if order.save
      # Vaciar el carrito después de crear la orden
      cart.destroy_all
      redirect_to order_path(order), notice: 'Order successfully created.'
    else
      redirect_to cart_path, alert: 'Error creating order. Please try again.'
    end
  end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :total_amount, :status, :gst, :pst)
    end
end
