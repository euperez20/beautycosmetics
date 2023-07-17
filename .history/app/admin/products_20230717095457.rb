ActiveAdmin.register Product do

  permit_params :name, :description, :price, :brand, :image, :category_id

  filter :category
  filter :colors

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :price
    column :brand
    column :category
    column :colors do |product|
      ul do
        product.colors.each do |color|
          li color.color_name
        end
      end
    end
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
      row :colors do |product|
        product.colors.pluck(:color_name).join(', ')
      end
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
      f.input :image, as: :file, hint: image_tag(f.object.image.url)
      # f.input :image, as: :file
      # f.input :colors, as: :check_boxes, collection: Color.all
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
