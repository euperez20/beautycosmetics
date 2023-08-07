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



  def checkout
    @provinces = Province.all
    province = Province.find_by(id: params[:province_id])
  
    # Total before taxes
    @subtotal = calculate_subtotal(session[:cart_items])
  
    if params[:calculate_taxes].present? && province.present? && province.gst.present? && province.pst.present?
      taxes = calculate_taxes(@subtotal, province.id)
      @gst = taxes[:gst]
      @pst = taxes[:pst]
      @hst = taxes[:hst]
      @total_amount_with_taxes = taxes[:total_amount_with_taxes]
      redirect_to cart_items_checkout_path
    else
      flash[:alert] = 'Invalid province selected or missing tax rates. Please try again.'
      redirect_to cart_items_path
      return
    end
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

# Calculate the total taxes based on the province's tax rates
total_gst = @subtotal * province.gst_rate
total_pst = @subtotal * province.pst_rate
total_hst = @subtotal * province.hst_rate
total_taxes = total_gst + total_pst + total_hst

# Calculate the total amount with taxes
total_amount_with_taxes = @subtotal + total_taxes

# Store the total amount with taxes in the session for later use in the checkout process
session[:total_amount_with_taxes] = total_amount_with_taxes

redirect_to cart_items_checkout_path 
end


  # def calculate_taxes
  #   @cart_items = session[:cart] || []
  #   @subtotal = calculate_subtotal(@cart_items) 
  #   @province = Province.find(params[:province_id])
  #   @gst = @subtotal * @province.gst_rate
  #   @pst = @subtotal * @province.pst_rate
  #   @total_after_taxes = @subtotal + @gst + @pst
  #   @provinces = Province.all
  #   @cart_items = session[:cart] || []
  #   render :index
  #   redirect_to checkout_path
  # end

  private

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item['price'].to_f * cart_item['quantity'].to_i }
  end

end
