ActiveAdmin.register Category do
  permit_params :name @category = @product.category
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Categories", path: categories_path },
      { name: @category.name, path: category_path(@category) },
      { name: @product.name, path: product_path(@product) }
    ]

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

  collection_action :index, method: :get do
    @categories = Category.page(params[:page]).per(10)  
  end

end
