require 'httparty'

# Define la URL de la API
url = 'http://makeup-api.herokuapp.com/api/v1/products.json'

# Realiza la solicitud GET a la API
response = HTTParty.get(url)

# Parsea los datos de la API como un arreglo de objetos JSON
products_data = JSON.parse(response.body)

# Crea las categorías
categories = products_data.map { |product| product['category'] }.uniq
categories.each do |category_name|
  Category.create!(name: category_name)
end

# Crea los colores
colors = products_data.map { |product| product['product_colors'] }.flatten.uniq
colors.each do |color_data|
  Color.create!(hex_value: color_data['hex_value'], color_name: color_data['colour_name'])
end

# Crea los productos y los relaciona con categorías y colores
products_data.each do |product_data|
  product = Product.create!(
    name: product_data['name'],
    description: product_data['description'],
    price: product_data['price'],
    brand: product_data['brand'],
    image: product_data['image_link']
  )

  # Encuentra o crea el color y lo relaciona con el producto
  color = Color.find_by(hex_value: product_data['product_colors'].first['hex_value'])
  product.product_colors.create!(color: color) if color

  # Encuentra la categoría y la relaciona con el producto
  category = Category.find_by(name: product_data['category'])
  product.category = category if category
  product.save!
end
