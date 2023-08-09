ActiveAdmin.register Color do
  
    permit_params :hex_value, :color_name
    config.filters = false
  
  index do
    selectable_column
    id_column
    column :color_name
    column :hex_value
    column :product_colors do |color|
      color.product_colors.count
    end
    actions
  end 

  
end
