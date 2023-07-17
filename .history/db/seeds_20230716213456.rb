require 'httparty'

# Make a request to the API to get the data
response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')

# Parse the response to get the product data
products = JSON.parse(response.body)

# Limit the products to 200
# products = products.first(200)

# Loop through the products and create the ProductColor records
products.each do |product|
  # Check if the product has colors
  if product['product_colors'].present?
    product['product_colors'].each do |color|
      # Find or create the Product record
      product_record = Product.find_or_create_by(name: product['name'], brand: product['brand'], description: product['description'], price: product['price'], image: product['image_link'])

      # Find or create the Color record
      color_record = Color.find_or_create_by(color_name: color['colour_name'], hex_value: color['hex_value'])

      # Create the ProductColor record
      ProductColor.create(product: product_record, color: color_record)
    end
  end
end
