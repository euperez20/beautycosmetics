ActiveAdmin.register Category do
  ransackable_attributes 'name'

  # Index View
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

  # Define los campos permitidos para la creación y edición
  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      # Agrega otros campos aquí si es necesario
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
