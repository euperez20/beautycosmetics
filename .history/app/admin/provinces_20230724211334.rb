ActiveAdmin.register Province do

  permit_params :name, :other_attribute

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :g
    end
    f.actions

  
end
