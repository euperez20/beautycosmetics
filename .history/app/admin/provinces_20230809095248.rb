ActiveAdmin.register Province do

  permit_params :name, :gst_rate, :pst_rate, :hst_rate 

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate

    end
    f.actions
    f.input total_amount_eq
  end 
end
