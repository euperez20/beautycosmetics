ActiveAdmin.register Product do

  permit_params :name, :description, :price, :brand, :image, :category_id
  

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :price
    column :brand
    column :category
    actions
  end

  # Define las columnas que se mostrarán en la vista de show
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row :brand
      row :category
      # Agrega otras columnas aquí si es necesario
    end
  end

  # Define los campos permitidos para la creación y edición
  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :brand
      f.input :category
      # Agrega otros campos aquí si es necesario
    end
    f.actions
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :category_id, :brand, :image
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :category_id, :brand, :image]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
