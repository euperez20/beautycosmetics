class OrdersController < ApplicationController
  before_action :set_order, only: %i[ edit update destroy update_partial]

  def index
    @orders = current_user.orders if user_signed_in?
  end

  def show
  end

  def new
    @cart_items = session[:cart_items] || []
    @subtotal = calculate_subtotal(@cart_items)
    @order = Order.new
  end

  def edit
    @order.modified_name = @order.name
    @order.modified_address = @order.address
    @order.modified_province_id = @order.province_id
  end

  # Update Order Taxes
  def update_partial
    @order = Order.find(params[:id])

    # Verificar si la actualización se realizó correctamente
    if @order.update(order_params)
      # Calcular los impuestos y el total de la orden con la nueva provincia
      @order.calculate_taxes(@order.province_id)

      # Renderizar la vista parcial con los nuevos datos
      respond_to do |format|
        format.json { render partial: 'order_details', locals: { order: @order }, status: :ok }
      end
    else
      # En caso de error en la actualización, responder con el error
      respond_to do |format|
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    # Obtener el carrito del usuario actual o desde la sesión
    cart_items = user_signed_in? ? current_user.cart_items : session[:cart_items]

    # Verificar si el usuario tiene una provincia y una dirección válida
    if user_signed_in? && (current_user.province.nil? || current_user.address.blank?)
      flash[:alert] = 'You must have a valid province and address in your profile before checkout.'
      redirect_to cart_items_path
      return
    end

    # Calcular el total sin impuestos sumando el precio de cada ítem en el carrito
    @subtotal = calculate_subtotal(cart_items)

    # Crear una nueva instancia de CartItem para el formulario de checkout
    @cart_item = CartItem.new(name: current_user&.name, address: current_user&.address, province_id: current_user&.province_id, total_amount_with_taxes: @subtotal)

    # Guardar la información necesaria en la sesión para calcular los impuestos y crear la orden más adelante
    session[:cart_item] = @cart_item.attributes.slice('name', 'address', 'province_id', 'total_amount_with_taxes', 'gst', 'pst', 'hst')

    redirect_to cart_items_checkout_path
  end

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

  # Update taxes JS
  def calculate_taxes
    order = Order.find(params[:order_id])
    province = Province.find(params[:province_id])

    # Calculate taxes and update the order
    order.calculate_taxes(province.id)
    order.save

    # Respond with the updated order details as JSON
    render json: {
      total_amount: order.total_amount,
      gst: order.gst,
      pst: order.pst,
      total_amount_with_taxes: order.total_amount_with_taxes
    }
  end

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

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:user_id, :total_amount, :status, :gst, :pst, :hst, :name, :province_id, :address)
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  end
end
