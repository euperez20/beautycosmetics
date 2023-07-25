ActiveAdmin.register User do
  permit_params :name, :address, :province_id, :admin


  index do
    selectable_column
    column :id
    column :name
    column :address
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
    end
    f.actions
  end
   
end
