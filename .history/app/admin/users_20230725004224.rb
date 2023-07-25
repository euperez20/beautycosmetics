ActiveAdmin.register User do
  permit_params :name, :address, :province_id, :admin


  index do
    selectable_column
    column :id
    column :name
    column :address
    column :province, as: :select, collection: Province.all, include_blank: "Select a province" # Muestra el nombre de la provincia en lugar del ID
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
      f.input :province_id
      f.input :admin
    end
    f.actions
  end
   
end
