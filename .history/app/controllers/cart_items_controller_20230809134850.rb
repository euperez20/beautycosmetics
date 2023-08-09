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

    flash[:cart_notice] = "Product successfully added to cart."
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
  
    # Get the values from the form and store them in instance variables
    @user_name = params[:name]
    @user_address = params[:address]
    @province_id = params[:province_id]
    @subtotal = params[:total_amount]
  
    # Calculate taxes and total amount with taxes
    if params[:calculate_taxes].present? && province.present? && province.gst.present? && province.pst.present?
      taxes = calculate_taxes(@subtotal, province.id)
      @gst = taxes[:gst]
      @pst = taxes[:pst]
      @hst = taxes[:hst]
      @total_amount_with_taxes = taxes[:total_amount_with_taxes]
    else
      flash[:alert] = 'Invalid province selected or missing tax rates. Please try again.'
      redirect_to cart_items_path
      return
    end
  end  

  
  def show    
    @user_name = session[:name]
    @user_address = session[:address]
    @province_name = session[:province_id]

    # Retrieve the total after taxes from the session
    @total_amount_with_taxes = session[:total_amount_with_taxes]    
    @cart_items = session[:cart_items] || []
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
    @cart_items = session[:cart_items] || []
    @subtotal = calculate_subtotal(@cart_items)

    # Get the user data from the form
    @user_name = params[:name]
    @user_address = params[:address]

    # Get the selected province_id from the form
    province_id = params[:province_id]
    province = Province.find_by(id: province_id)
    
    if province.nil? || province.gst_rate.nil? || province.pst_rate.nil?
      flash[:alert] = 'Invalid province selected. Please try again.'
      redirect_to cart_items_checkout_path
      return
    end

    # Calculate the total taxes based on the province's tax rates
    total_gst = @subtotal * province.gst_rate
    total_pst = @subtotal * province.pst_rate
    total_hst = @subtotal * province.hst_rate    
    total_taxes = total_gst + total_pst + total_hst
    @total_amount_with_taxes = @subtotal + total_taxes


    # Store all the relevant information in the session
    session[:total_amount] = @subtotal
    session[:total_amount_with_taxes] = @total_amount_with_taxes
    session[:user_name] = @user_name
    session[:user_address] = @user_address
    session[:email] = params[:email]
    session[:province_id] = province_id
    session[:total_gst] = total_gst
    session[:total_pst] = total_pst
    session[:total_hst] = total_hst  

    redirect_to cart_items_checkout_path
  end


  private

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item['price'].to_f * cart_item['quantity'].to_i }
  end

end
