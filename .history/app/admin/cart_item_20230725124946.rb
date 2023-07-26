ActiveAdmin.register CartItem do
    # Configura los campos que deseas mostrar en la tabla de índice y el formulario de edición
    permit_params :cart_id, :product_id, :quantity
  
    index do
      selectable_column
      id_column
      column :cart
      column :product
      column :quantity
      actions
    end
  
    form do |f|
      f.inputs "Cart Item Details" do
        f.input :cart
        f.input :product
        f.input :quantity
      end
      f.actions
    end
  end
  