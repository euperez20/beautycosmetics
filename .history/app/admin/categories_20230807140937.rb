ActiveAdmin.register Category do
  permit_params :name, :other_attribute, :another_attribute

  controller do
    def index
      # Asegúrate de paginar la colección usando kaminari
      @categories = Category.page(params[:page]).per(10)
    end
  end
  
  # Views
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


  
end
