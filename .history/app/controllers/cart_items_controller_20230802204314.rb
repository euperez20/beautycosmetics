class CartItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @cart_items = session[:cart_items] || []
    @subtotal = calculate_subtotal(@cart_items)
  end

  def create
    product_id = params[:product_id].to_i
    @cart_item = current_user.cart_items.find_by(product_id: product_id)

    if @cart_item
      @cart_item.quantity += 1
    else
      @cart_item = current_user.cart_items.new(product_id: product_id, quantity: 1)
    end

    if @cart_item.save
      redirect_back(fallback_location: root_path, notice: 'Item added to cart!')
    else
      flash[:alert] = 'Unable to add item to cart.'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Product removed from cart.'
  end

  def cart_count
    @cart_count = current_user.cart_items.sum(:quantity) if user_signed_in?
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: 'Item updated successfully.'
    else
      render :index
    end
  end

  def checkout
    # Get current cart
    cart_items = current_user.cart_items

    # Verificar si el usuario tiene una provincia y una dirección válida
    if current_user.province.nil? || current_user.address.blank?
      flash[:alert] = 'You must have a valid province and address in your profile before checkout.'
      redirect_to cart_items_path
      return
    end

    # Calcular el total sin impuestos sumando el precio de cada ítem en el carrito
    @subtotal = calculate_subtotal(cart_items)

    # Crear una nueva instancia de CartItem para el formulario de checkout
    @cart_item = CartItem.new(name: current_user.name, address: current_user.address, province_id: current_user.province_id, total_amount_with_taxes: @subtotal)

    # Guardar la información necesaria en la sesión para calcular los impuestos y crear la orden más tarde
    session[:cart_item] = @cart_item.attributes.slice('name', 'address', 'province_id', 'total_amount_with_taxes', 'gst', 'pst', 'hst')
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  end
end
