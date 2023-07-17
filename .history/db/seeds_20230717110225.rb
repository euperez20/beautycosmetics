require 'httparty'

# Hacemos una solicitud HTTP para obtener la lista de productos desde el API
response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')

# Parseamos la respuesta JSON
products_data = JSON.parse(response.body)

# Iteramos sobre los datos de los productos y creamos o actualizamos los registros
products_data.each do |product_data|
  product = Product.find_or_initialize_by(name: product_data['name'])
  product.description = product_data['description']
  product.price = product_data['price']
  product.brand = product_data['brand']

  # Adjuntamos la imagen desde la URL proporcionada por el API
  image_url = product_data['image_link']
  product.image.attach(io: URI.open(image_url), filename: "product_image.jpg")

  # Guardamos el producto en la base de datos
  product.save
end
