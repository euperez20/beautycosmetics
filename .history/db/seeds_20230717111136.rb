require 'json'
require 'net/http'

url = URI.parse('https://makeup-api.herokuapp.com/api/v1/products.json')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url.request_uri)
response = http.request(request)
products_data = JSON.parse(response.body)

products_data.each do |product_data|
  product = Product.create!(
    name: product_data['name'],
    description: product_data['description'],
    price: product_data['price'],
    brand: product_data['brand'],
    image_link: product_data['image_link'] # Use the 'image_link' field from the API data
  )

  colors = product_data['product_colors']
  colors.each do |color_data|
    color = Color.find_or_create_by(color_name: color_data['colour_name'])
    product.colors << color
  end
end
