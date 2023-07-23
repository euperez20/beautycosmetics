ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :admin, name: 

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
    end
    f.actions
  end

  
end
