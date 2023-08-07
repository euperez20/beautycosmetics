class CartItemsController < ApplicationController
  def index
    @categories = Category.all
    @cart_items = session[:cart_items] || []
    @subtotal = calculate_subtotal(@cart_items)
    @provinces = Province.all
    @product_added = session.delete(:product_added)
    @subtotal = calculate_subtotal(@cart_items)
  end

  def create
    product_id = params[:product_id].to_i
    product = Product.find_by(id: product_id)
  
    if product.nil?
      flash[:alert] = 'Product not found. Please try again.'
      redirect_back(fallback_location: root_path)
      return
    end
  
    cart_item = { product_id: product_id, quantity: 1, price: product.price }
    session[:cart_items] ||= []
    session[:cart_items] << cart_item

  
    redirect_back(fallback_location: root_path, notice: 'Item added to cart!')
    
  end



  def destroy
    product_id = params[:product_id].to_i
    session[:cart_items].delete_if { |item| item['product_id'] == product_id }
    redirect_to cart_items_path, notice: 'Product removed from cart.'
  end

  def cart_count
    @cart_count = session[:cart_items]&.sum { |item| item['quantity'] } || 0
  end

  def update
    product_id = params[:id].to_i
    quantity = params[:cart_item][:quantity].to_i
    session[:cart_items]&.each do |item|
      item['quantity'] = quantity if item['product_id'] == product_id
    end

    redirect_to cart_items_path, notice: 'Item updated successfully.'
  end

  # def checkout
  #   @provinces = Province.all
  #   province = Province.find_by(id: params[:province_id])
  
  #   # Total before taxes
  #   @subtotal = calculate_subtotal(session[:cart_items])
  
  #   if params[:calculate_taxes].present? && province.present? && province.gst.present? && province.pst.present?
  #     taxes = calculate_taxes(@subtotal, province.id)
  #     @gst = taxes[:gst]
  #     @pst = taxes[:pst]
  #     @hst = taxes[:hst]
  #     @total_amount_with_taxes = taxes[:total_amount_with_taxes]
  #   else
  #     flash[:alert] = 'Invalid province selected or missing tax rates. Please try again.'
  #     redirect_to cart_items_path
  #     return
  #   end
  # end

  def checkout
    # Verificar si el usuario ha proporcionado los datos necesarios (nombre, dirección, provincia)
    if session[:user_name].blank? || session[:user_address].blank? || session[:province_id].blank?
      flash[:alert] = 'Please provide your name, address, and select a valid province.'
      redirect_to cart_items_path
      return
    end

    # Obtener todos los elementos del carrito desde la sesión.
    @cart_items = session[:cart_items] || []

    # Obtener el ID de la provincia seleccionada desde la sesión.
    province_id = session[:province_id]

    # Buscar la provincia en la base de datos.
    province = Province.find_by(id: province_id)

    # Verificar si la provincia es válida y tiene tasas de impuestos definidas.
    if province.nil? || province.gst_rate.nil? || province.pst_rate.nil?
      flash[:alert] = 'Invalid province selected or missing tax rates. Please try again.'
      redirect_to cart_items_path
      return
    end

    # Calcular el total antes de impuestos.
    @subtotal = calculate_subtotal(@cart_items)

    # Calcular los impuestos basados en las tasas de impuestos de la provincia.
    total_gst = @subtotal * province.gst_rate
    total_pst = @subtotal * province.pst_rate
    total_taxes = total_gst + total_pst

    # Calcular el total después de impuestos.
    @total_amount_with_taxes = @subtotal + total_taxes

    # Guardar el total después de impuestos en la sesión para su posterior uso.
    session[:total_amount_with_taxes] = @total_amount_with_taxes

    # Redirigir a la vista show (checkout) para mostrar los detalles del carrito y el total después de impuestos.
    redirect_to cart_item_path
  end



  def calculate_taxes_and_proceed_to_checkout
    province_id = params[:province_id]
    province = Province.find_by(id: province_id)

    # Check if the province is found and has valid tax rates
    if province.nil? || province.gst_rate.nil? || province.pst_rate.nil?
      flash[:alert] = 'Invalid province selected. Please try again.'
      redirect_to cart_items_checkout_path
      return
    end

    # Total before taxes
    @subtotal = calculate_subtotal(session[:cart_items])

    # Calculate the total taxes based on the province's tax rates
    total_gst = @subtotal * province.gst_rate
    total_pst = @subtotal * province.pst_rate
    total_taxes = total_gst + total_pst

    # Calculate the total amount with taxes
    @total_amount_with_taxes = @subtotal + total_taxes

    # Save the total amount with taxes in the session for later use
    session[:total_amount_with_taxes] = @total_amount_with_taxes

    redirect_to checkout_path 
  end
  
  
  # def show   
  #   @cart = session[:cart] || {}    
  #   item_id = params[:id]   
  #   @cart_item = @cart[item_id]    
  # end
  
  def show
    # Recuperar los valores del usuario desde la sesión.
    @user_name = session[:user_name]
    @user_address = session[:user_address]
    @province_id = session[:province_id]

    # Verificar si se proporcionaron los valores del usuario.
    if @user_name.blank? || @user_address.blank? || @province_id.blank?
      flash[:alert] = 'Please provide your name, address, and select a valid province.'
      redirect_to cart_items_path
      return
    end

    # Obtener todos los elementos del carrito desde la sesión.
    @cart_items = session[:cart_items] || []

    # Buscar la provincia en la base de datos.
    province = Province.find_by(id: @province_id)

    # Verificar si la provincia es válida y tiene tasas de impuestos definidas.
    if province.nil? || province.gst_rate.nil? || province.pst_rate.nil?
      flash[:alert] = 'Invalid province selected or missing tax rates. Please try again.'
      redirect_to cart_items_path
      return
    end

    # Calcular el total antes de impuestos.
    @subtotal = calculate_subtotal(@cart_items)

    # Calcular los impuestos basados en las tasas de impuestos de la provincia.
    total_gst = @subtotal * province.gst_rate
    total_pst = @subtotal * province.pst_rate
    total_taxes = total_gst + total_pst

    # Calcular el total después de impuestos.
    @total_amount_with_taxes = @subtotal + total_taxes

    # Guardar el total después de impuestos en la sesión para su posterior uso.
    session[:total_amount_with_taxes] = @total_amount_with_taxes

    # Renderizar la vista show.html.erb para mostrar los detalles del carrito y el total después de impuestos.
    render :show
  end



  def remove_from_cart
    product_id = params[:product_id].to_i
    session[:cart_items] = session[:cart_items].reject { |item| item['product_id'] == product_id }

    redirect_to cart_items_path, notice: 'Product removed from cart.'
  end

  def update
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    if quantity <= 0
      
      session[:cart_items] = session[:cart_items].reject { |item| item['product_id'] == product_id }
      flash[:notice] = 'Product removed from cart.'
    else
      
      session[:cart_items].each do |item|
        if item['product_id'] == product_id
          item['quantity'] = quantity
          break
        end
      end
      flash[:notice] = 'Quantity updated.'
    end

    redirect_to cart_items_path
  end

  def calculate_taxes
    # Fetch the cart items from the session
    @cart_items = session[:cart] || []

    # Calculate the subtotal before taxes
    @subtotal = calculate_subtotal(@cart_items)

    # Get the selected province_id from the form
    province_id = params[:province_id]

# Fetch the selected province from the database based on the province_id
province = Province.find_by(id: params[:province_id])

# Check if the province is found and has valid tax rates
if province.nil? || province.gst_rate.nil? || province.pst_rate.nil?
  flash[:alert] = 'Invalid province selected. Please try again.'
  redirect_to cart_items_path
  return
end

# Calculate the total 
total_gst = @subtotal * province.gst_rate
total_pst = @subtotal * province.pst_rate
total_hst = @subtotal * province.hst_rate
total_taxes = total_gst + total_pst + total_hst
total_amount_with_taxes = @subtotal + total_taxes

session[:total_amount_with_taxes] = total_amount_with_taxes

redirect_to cart_items_checkout_path 
end


  private

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item['price'].to_f * cart_item['quantity'].to_i }
  end

end
