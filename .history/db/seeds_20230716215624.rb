require 'json'
require 'net/http'

# Define el endpoint del API para obtener los productos
url = URI.parse('http://makeup-api.herokuapp.com/api/v1/products.json')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == 'https')

# Realiza la solicitud HTTP GET al API y parsea los datos JSON
request = Net::HTTP::Get.new(url.request_uri)
response = http.request(request)
products_data = JSON.parse(response.body)

# Itera sobre los datos del API y crea registros de productos y colores en la base de datos
products_data.each do |product_data|
  product = Product.create!(
    name: product_data['name'],
    description: product_data['description'],
    price: product_data['price'],
    brand: product_data['brand'],
    # Otras columnas relevantes del modelo Product
  )

  # Crea registros de colores asociados al producto actual
  product_data['product_colors'].each do |product_color_data|
    color = Color.find_or_create_by!(
      color_name: product_color_data['colour_name'],
      hex_value: product_color_data['hex_value'],
      # Otras columnas relevantes del modelo Color
    )
    
    ProductColor.create!(
      product: product,
      color: color,
      # Otras columnas relevantes del modelo ProductColor
    )
  end
end
