ActiveAdmin.register OrderItem do
    # Order Items configuration
    permit_params :order_id, :product_id, :quantity, :price
  
    index do
      selectable_column
      column :id
      column :order
      column :product
      column :quantity
      column :price
      actions
    end
  
    form do |f|
      f.inputs "Order Item Details" do
        f.input :order
        f.input :product
        f.input :quantity
        f.input :price
      end
      f.actions
    end
  end
  