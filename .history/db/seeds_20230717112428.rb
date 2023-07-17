require 'json'
require 'net/http'

url = URI.parse('https://makeup-api.herokuapp.com/api/v1/products.json')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url.request_uri)
response = http.request(request)
products_data = JSON.parse(response.body)

products_data.each do |product_data|
  product = Product.find_or_initialize_by(name: product_data['name'])

  if product_data['image_link'].present?
    product.image.attach(io: URI.open(product_data['image_link']), filename: "#{product.name.parameterize}.jpg")
  end

  product.save
end
