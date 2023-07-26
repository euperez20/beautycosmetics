ActiveAdmin.register Order do
    # ... Otros registros y configuraciones
  
    member_action :past_orders, method: :get do
      @order = Order.find(params[:id])
    end
  end
  