class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy update_partial]

  def index
    @categories = Category.all
    if user_signed_in?
      @orders = current_user.orders
    else
      @orders = []
    end    
  end

  def show
    if @order.nil?
      flash[:error] = "Order not found." 
      redirect_to orders_path 
    else
      render 'orders/show'
    end
  end


  def search
    email = params[:order][:email]
    order_number = params[:order][:order_number]
    @order = Order.find_by(email: email, order_number: order_number)

    if @order
      render :show_search_result
    else
      flash[:notice] = "Order not found."
      redirect_to new_search_orders_path
    end
  end

  def search_results
    email = params[:email]
    order_number = params[:order_number]
    @order = Order.find_by(email: email, order_number: order_number)

    if @order
      render :search_results
    else
      flash[:notice] = "Order not found."
      render :search
    end
  end

  def new_search
    
    @order = Order.new
  end

  def new

  end

  def edit
    @order.modified_name = @order.name
    @order.modified_address = @order.address
    @order.modified_province_id = @order.province_id
  end

  # Update Order Taxes
  def update_partial
    @order = Order.find(params[:id])
    
    if @order.update(order_params)      
      @order.calculate_taxes(@order.province_id)      
      respond_to do |format|
        format.json { render partial: 'order_details', locals: { order: @order }, status: :ok }
      end
    else
      
      respond_to do |format|
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    puts "Parameters: #{params.inspect}"

    # Get sessions information
    user_name = session[:user_name]
    user_address = session[:user_address]
    province_id = session[:province_id]
    total_gst = session[:total_gst]
    total_pst = session[:total_pst]
    total_hst = session[:total_hst]
    total_amount_with_taxes = session[:total_amount_with_taxes]
    cart_items = session[:cart_items]

    # Create order
  province = Province.find_by(id: province_id)
  order = Order.new(
    name: user_name,
    address: user_address,
    status: 'pending',
    province: province,
    province_id: province_id,
    gst: total_gst,
    pst: total_pst,
    hst: total_hst,
    total_amount_with_taxes: total_amount_with_taxes,
    email: session[:email] 
  )

  
  if user_signed_in?
    order.user = current_user
  end
            puts "Order created: #{order.inspect}"

    
    if order.save
      
      cart_items.each do |cart_item|
        product = Product.find_by(id: cart_item['product_id'])
        next unless product

        order.order_items.create(
          product_id: cart_item['product_id'],
          quantity: cart_item['quantity'],
          price: cart_item['price'].to_f
        )
      end

      # Delete session information
      session.delete(:user_name)
      session.delete(:user_address)
      session.delete(:province_id)
      session.delete(:total_gst)
      session.delete(:total_pst)
      session.delete(:total_hst)
      session.delete(:total_amount_with_taxes)
      session.delete(:cart_items)
     
      redirect_to order_path(order), notice: 'Order created successfully.'
    else
      Rails.logger.error "Failed to save the order: #{order.errors.full_messages.join(', ')}"      
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

  # def set_order
  #   @order = Order.find(params[:id])
  # end

  def set_order
    if params[:id] == 'search'
      # Si el parámetro es 'search', no intentes buscar una orden
      @order = nil
    else
      # Si el parámetro no es 'search', busca la orden normalmente por ID
      @order = Order.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:user_id, :total_amount, :total_amount_with_taxes, :status, :gst, :pst, :hst, :name, :province_id, :address, :email)
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
  end
end
