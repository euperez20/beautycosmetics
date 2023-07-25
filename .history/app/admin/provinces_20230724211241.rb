ActiveAdmin.register Province do

  permit_params :name, :other_attribute

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      # Otros campos que desees mostrar en el formulario
    end
    f.actions

  
end
