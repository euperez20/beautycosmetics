class OrdersController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy update_partial]

  def index
    if user_signed_in?
      @orders = current_user.orders
    else
      @orders = []
    end
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
    def create
      # Obtener los datos de la sesión
      user_name = session[:user_name]
      user_address = session[:user_address]
      province_id = session[:province_id]
      total_gst = session[:total_gst]
      total_pst = session[:total_pst]
      total_hst = session[:total_hst]
      total_amount_with_taxes = session[:total_amount_with_taxes]
      cart_items = session[:cart_items]
  
      # Verificar si el usuario está autenticado
      if user_signed_in?
        # Crear la orden y asociarla con el usuario actual
        order = current_user.orders.new(
          name: user_name,
          address: user_address,
          province: Province.find_by(id: province_id)&.name,
          gst: total_gst,
          pst: total_pst,
          hst: total_hst,
          total_amount_with_taxes: total_amount_with_taxes,
          email: params[:email]  # Aquí está el campo de correo electrónico
        )
      else
        # Crear la orden sin asociarla con un usuario
        order = Order.new(
          name: user_name,
          address: user_address,
          province: Province.find_by(id: province_id)&.name,
          gst: total_gst,
          pst: total_pst,
          hst: total_hst,
          total_amount_with_taxes: total_amount_with_taxes,
          email: params[:email]  # Aquí está el campo de correo electrónico
        )
      end


    # Guardar la orden en la base de datos
    if order.save
      # Crear los elementos de la orden (order items) y asociarlos con la orden
      cart_items.each do |cart_item|
        product = Product.find_by(id: cart_item['product_id'])
        next unless product

        order.order_items.create(
          product_id: cart_item['product_id'],
          quantity: cart_item['quantity'],
          price: cart_item['price'].to_f
        )
      end

      # Eliminar la información de la sesión después de crear la orden
      session.delete(:user_name)
      session.delete(:user_address)
      session.delete(:province_id)
      session.delete(:total_gst)
      session.delete(:total_pst)
      session.delete(:total_hst)
      session.delete(:total_amount_with_taxes)
      session.delete(:cart_items)

      # Redirigir a una página de éxito o mostrar un mensaje de éxito
      redirect_to root_path, notice: 'Order created successfully.'
    else
    # Imprimir los errores en el registro para depuración
    puts order.errors.full_messages
      # Si no se pudo guardar la orden, redirigir a alguna página de error o mostrar un mensaje de error
      redirect_to cart_items_checkout_path, alert: 'Failed to create order. Please try again.'
    end
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
    params.require(:order).permit(:user_id, :total_amount, :status, :gst, :pst, :hst, :name, :province_id, :address, :email)
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  end
end
