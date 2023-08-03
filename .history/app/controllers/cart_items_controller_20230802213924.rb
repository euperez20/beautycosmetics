class CartItemsController < ApplicationController
  def index
    @cart_items = session[:cart_items] || []
    @subtotal = calculate_subtotal(@cart_items)
    @provinces = Province.all
    @product_added = session.delete(:product_added)
    @subtotal = calculate_subtotal(@cart_items)
  end

  def create
    product_id = params[:product_id].to_i
    cart_item = { product_id: product_id, quantity: 1, price: Product.find(product_id).price }
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

  def checkout
    # Check if the cart is not empty
    if session[:cart_items].blank?
      flash[:alert] = 'Your cart is empty. Please add items to the cart before proceeding to checkout.'
      redirect_to cart_items_path
      return
    end

    # Check user data
    if current_user.nil? || current_user.province.nil? || current_user.address.blank?
      flash[:alert] = 'You must provide valid user data before checkout.'
      redirect_to cart_items_path
      return
    end

    # Total before taxes
    @subtotal = calculate_subtotal(session[:cart_items])

    # Create checkout form with user data
    @checkout_data = {
      name: current_user.name,
      address: current_user.address,
      province_id: current_user.province.id,
      total_amount_with_taxes: @subtotal
    }
  end

  private

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item['price'].to_f * cart_item['quantity'].to_i }
  end
end
