permit_params :user_id, :total_amount, :status, :gst, :pst

  index do
    selectable_column
    column :id
    column :user
    column :total_amount
    column :status
    column :gst
    column :pst
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :total_amount
      f.input :status
      f.input :gst
      f.input :pst
    end
    f.actions
  end
end
end