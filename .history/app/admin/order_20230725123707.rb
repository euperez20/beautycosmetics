# app/admin/order.rb
ActiveAdmin.register Order do
    # Configurar qué columnas se muestran en la lista de órdenes
    index do
      selectable_column
      id_column
      column :user
      column :status
      column :total_amount
      actions
    end

      # def self.ransackable_attributes(auth_object = nil)
  #   ["address", "created_at", "gst", "hst", "id", "province", "pst", "status", "total_amount", "total_amount_with_taxes", "updated_at", "user_id"]
  # end
  
    # Definir la acción personalizada para mostrar las órdenes pasadas y sus detalles
    member_action :past_orders, method: :get do
      @order = Order.find(params[:id])
    end
  
    # Configurar las rutas y enlaces para la acción personalizada
    action_item :past_orders, only: :show do
      link_to 'Past Orders', past_orders_admin_order_path(order)
    end
  
    # Configurar el enlace en la lista de órdenes
    action_item :view, only: :show do
      link_to 'View Order', admin_order_path(order)
    end
  
    # Configurar la ruta para la acción personalizada
    member_action :past_orders, method: :get do
      @order = Order.find(params[:id])
    end
  end
  