# Primero, asegúrate de tener una copia de seguridad de tu base de datos antes de ejecutar los cambios.

# Eliminar todos los registros existentes de product_colors
ProductColor.destroy_all

# Obtener los datos de la API y crear productos y product_colors
url = URI.parse('http://makeup-api.herokuapp.com/api/v1/products.json')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url.request_uri)
response = http.request(request)
products_data = JSON.parse(response.body)

products_data.first(200).each do |product_data|
  category = Category.find_or_create_by(name: product_data['category'])
  product = Product.create!(
    name: product_data['name'],
    description: product_data['description'],
    price: product_data['price'].to_f,
    brand: product_data['brand'],
    category: category # Asignar la categoría existente al producto
  )

  product_data['product_colors'].each do |color_data|
    color = Color.find_or_create_by(color_name: color_data['colour_name'], hex_value: color_data['hex_value'])
    ProductColor.create!(product: product, color: color)
  end
end
