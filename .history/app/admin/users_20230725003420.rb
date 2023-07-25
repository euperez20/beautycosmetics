ActiveAdmin.register User do
  permit_params :name, :address, :province_id, :admin


  

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
