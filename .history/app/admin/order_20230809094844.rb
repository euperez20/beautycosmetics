ActiveAdmin.register Order do
 
  
  permit_params :user_id, :total_amount, :status, :gst, :pst, :hst, :total_amount_with_taxes, :status, :name, :province_id, :address, :email

  index do
    selectable_column
    id_column
    column :user    
    column :total_amount
    column :total_amount_with_taxes
    column :status
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      # f.input :total_amount
      f.input :status, as: :select, collection: Order.statuses.keys
      f.input :gst
      f.input :pst
      f.input :hst
      
    end
    f.actions
  end
end
