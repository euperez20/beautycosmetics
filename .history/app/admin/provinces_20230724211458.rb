ActiveAdmin.register Province do

  permit_params :name, :other_attribute

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate

    end
    f.actions

 End 
end
