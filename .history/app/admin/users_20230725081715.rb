ActiveAdmin.register User do
  permit_params :name, :address, :province_id, :admin, :email, :password, :password_confirmation


  index do
    selectable_column
    column :id
    column :name
    column :address
    column
    column :province
    column :admin
    actions
  end
  
  filter :name
  filter :address
  filter :province, as: :select, collection: Province.all

  form do |f|
    f.inputs do
      f.input :name
      f.input :address
      f.input :province_id, as: :select, collection: Province.all, include_blank: "Select a province"
      f.input :admin
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
   
end
