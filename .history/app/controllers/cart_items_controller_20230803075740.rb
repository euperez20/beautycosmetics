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
    # Check if the cart is not empty
    if session[:cart_items].blank?
      flash[:alert] = 'Your cart is empty. Please add items to the cart before proceeding to checkout.'
      # redirect_to cart_items_path
      redirect_to checkout_path
      return
    end
  
    # Check user data
    if current_user.nil? || current_user.province.nil? || current_user.address.blank?
      flash[:alert] = 'You must provide valid user data before checkout.'
      # redirect_to cart_items_path
      redirect_to checkout_path
      return
    end
  
    # Total before taxes
    @subtotal = calculate_subtotal(session[:cart_items])
  
    if params[:calculate_taxes].present?
      province_id = current_user.province.id
      taxes = calculate_taxes(@subtotal, province_id)
      @gst = taxes[:gst]
      @pst = taxes[:pst]
      @hst = taxes[:hst]
      @total_with_taxes = taxes[:total_amount_with_taxes]
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
    @cart_items = session[:cart] || []
    @subtotal = calculate_subtotal(@cart_items)

    # Calculate taxes and other required values
    gst = @subtotal * 0.05 
    pst = @subtotal * 0.08 
    total_amount_with_taxes = @subtotal + gst + pst

    # Store the calculated values in the session for use in the checkout page
    session[:subtotal] = @subtotal
    session[:gst] = gst
    session[:pst] = pst
    session[:total_amount_with_taxes] = total_amount_with_taxes

    redirect_to checkout_path # Redirect to the checkout page
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
  # end

  private

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item['price'].to_f * cart_item['quantity'].to_i }
  end

end
