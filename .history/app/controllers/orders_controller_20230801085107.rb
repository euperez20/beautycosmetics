class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]

  def index
    # @orders = Order.all
    @orders = current_user.orders
  end

  
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
    @order.modified_name = @order.name
    @order.modified_address = @order.address
    @order.modified_province_id = @order.province_id
  end

  # POST /orders or /orders.json
  def create
    # Si se recibe el parámetro :id, se actualizará una orden existente
    if params[:id].present?
      @order = Order.find(params[:id])
      @order.assign_attributes(order_params)

      # Utiliza los valores modificados si están presentes, de lo contrario, utiliza los valores originales de la orden
      @order.name = @order.modified_name.presence || @order.name
      @order.address = @order.modified_address.presence || @order.address
      @order.province_id = @order.modified_province_id.presence || @order.province_id

      # Calcular los impuestos y el total de la orden
      @order.calculate_taxes(@order.province_id)

      if @order.save
        redirect_to @order, notice: 'Order successfully updated.'
      else
        render :edit
      end
    else
      # Si no se recibe el parámetro :id, se creará una nueva orden
      cart = current_user.cart_items

      # Verificar si el usuario tiene una provincia y una dirección válida
      if current_user.province.nil? || current_user.address.blank?
        flash[:alert] = 'You must have a valid province and address in your profile before checkout.'
        redirect_to cart_path
        return
      end

      # Calcular el total de la orden sumando el precio de cada ítem en el carrito
      total_amount = cart.sum { |cart_item| cart_item.product.price * cart_item.quantity }

      # Crear una nueva orden asociada al usuario con el total calculado
      @order = current_user.orders.build(total_amount: total_amount, status: 'pending')

      # Agregar cada elemento del carrito como un ítem de la orden
      cart.each do |cart_item|
        @order.order_items.build(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
      end

      # Asignar la dirección y la provincia del usuario a la orden
      @order.name = current_user.name
      @order.address = current_user.address

      # Buscar el objeto Province asociado al nombre de la provincia en la base de datos
    province = Province.find_by(name: current_user.province.name)
    @order.province = province if province

      # Calcular los impuestos y el total de la orden
      @order.calculate_taxes(current_user.province_id)

      # Guardar la orden en la base de datos
      if @order.save
        # Vaciar el carrito después de crear la orden
        cart.destroy_all
        redirect_to @order, notice: 'Order successfully created.'
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

  def set_order
    @order = Order.find(params[:id])
  end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:user_id, :total_amount, :status, :gst, :pst, :hst, :name, :province_id, :address )
    end
end
