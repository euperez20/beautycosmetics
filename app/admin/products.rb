ActiveAdmin.register Product do

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  permit_params :name, :description, :price, :brand, :image, :category_id, :featured

  filter :category
  filter :colors
  filter :name

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :price
    column :brand
    column :category
    column :featured
    # Sowing image in index
    # column :image do |product|
    #   image_tag(product.image.url, width: 100) if product.image.attached?
    # end

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
      row :featured
      row :image

      
    

 # Image
  # Image
  row :image do |product|
    if product.image.is_a?(ActiveStorage::Attached::One) && product.image.attached?
      image_tag url_for(product.image), style: 'max-width: 300px;'
    elsif product.image.is_a?(String) && product.image.start_with?('http')
      image_tag product.image, style: 'max-width: 300px;'
    else
      content_tag(:span, 'No image available')
    end
  end
    
      active_admin_comments
        
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
      f.input :featured

      
      f.input :image, as: :file
      # f.input :image, as: :file, hint: image_tag(f.object.image.url)
      # f.input :colors, as: :check_boxes, collection: Color.all
    end
    f.actions
  end
  
end
