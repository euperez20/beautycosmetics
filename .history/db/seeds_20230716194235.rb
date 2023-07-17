require 'httparty'

begin
  # Step 1: Crear categorías y obtener sus nombres
  categories_response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')
  categories_data = JSON.parse(categories_response.body)

  # Step 2: Crear un hash para almacenar las categorías y sus ids
  categories_hash = {}

  categories_data.each do |product_data|
    category_name = product_data['category']

    # Verificar si la categoría ya existe en el hash o en la base de datos
    category = Category.find_or_create_by(name: category_name)

    # Almacenar el id de la categoría en el hash para usarlo luego
    categories_hash[category_name] = category.id
  end
rescue StandardError => e
  puts "Error creating categories: #{e.message}"
end

# Step 3: Crear productos y asignarles categorías existentes
categories_data.each do |product_data|
  category_name = product_data['category']

  # Verificar si la categoría existe en el hash antes de crear el producto
  if categories_hash[category_name].present?
    Product.create!(
      name: product_data['name'],
      description: product_data['description'],
      price: product_data['price'],
      brand: product_data['brand'],
      image: product_data['image'],
      category_id: categories_hash[category_name] # Asignamos el id de la categoría correspondiente
    )
  end
end
