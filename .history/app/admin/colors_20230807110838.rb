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
  

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :hex_value, :color_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:hex_value, :color_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
