ActiveAdmin.register ProductColor do

  permit_params :product_id, :color_id

  index do
    selectable_column
    id_column
    column :product
    column :color
    actions
  end

  form do |f|
    f.inputs do
      f.input :product
      f.input :color, as: :select, collection: Color.pluck(:color_name, :id)
    end
    f.actions
  end
  
end
