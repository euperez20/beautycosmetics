ActiveAdmin.register Category do
  permit_params :name, :other_attribute, :another_attribute

  # Vi
  index do
    selectable_column
    column :id
    column :name
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :name
      
    end
  end

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      
    end
    f.actions
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
