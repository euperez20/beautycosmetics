ActiveAdmin.register ProductColor do

  permit_params :name, :description, :price, :brand, :image, category_ids: [], color_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :brand
    column :colors do |product|
      product.colors.pluck(:color_name).join(', ')
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :brand
      f.input :colors, as: :check_boxes, collection: Color.pluck(:color_name, :id)
    end
    f.actions
  end
  
end
