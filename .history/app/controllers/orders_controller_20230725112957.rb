class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
    @orders = current_user.orders
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @cart_items = current_user.cart_items.includes(:product)
    @total = @cart_items.sum(&:subtotal)
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    # Obtener el carrito del usuario actual
    cart = current_user.cart_items
  
    # Calcular el total de la orden sumando el precio de cada ítem en el carrito
    total_amount = cart.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  
    # Crear una nueva orden asociada al usuario con el total calculado
    order = current_user.orders.build(total_amount: total_amount, status: 'pending')
  
    # Agregar cada elemento del carrito como un ítem de la orden
    cart.each do |cart_item|
      order.order_items.build(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
    end
  
    # Asignar la dirección y la provincia del usuario a la orden
    order.address = current_user.address
    order.province = current_user.province
  
    # Calcular los impuestos y el total de la orden
    order.calculate_taxes(current_user.province_id)
  
    # Guardar la orden en la base de datos
    if order.save
      # Vaciar el carrito después de crear la orden
      cart.destroy_all
      redirect_to order_path(order), notice: 'Order successfully created.'
    else
      redirect_to cart_path, alert: 'Error creating order. Please try again.'
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
