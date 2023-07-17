require 'json'
require 'net/http'

# Método para cargar datos desde la API
def load_data_from_api(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

# Seed para cargar colores desde la API
def seed_colors
  colors_data = load_data_from_api('http://makeup-api.herokuapp.com/api/v1/products.json')

  colors_data.each do |color_data|
    Color.find_or_create_by!(
      color_name: color_data['name'],
      hex_value: color_data['hex_value']
    )
  end
end

# # Seed para cargar categorías desde la API
# def seed_categories
#   categories_data = load_data_from_api('http://makeup-api.herokuapp.com/api/v1/products.json').map { |product_data| product_data['category'] }.uniq

#   categories_data.each do |category_name|
#     Category.find_or_create_by!(name: category_name)
#   end
# end

# # Seed para cargar productos desde la API
# def seed_products
#   products_data = load_data_from_api('http://makeup-api.herokuapp.com/api/v1/products.json')

#   products_data.each do |product_data|
#     category = Category.find_or_create_by!(name: product_data['category'])

#     product = Product.create!(
#       name: product_data['name'],
#       description: product_data['description'],
#       price: product_data['price'],
#       brand: product_data['brand'],
#       category: category
#     )

#     product_data['product_colors'].each do |product_color_data|
#       color = Color.find_or_create_by!(
#         color_name: product_color_data['color_name'],
#         hex_value: product_color_data['hex_value']
#       )

#       ProductColor.create!(
#         product: product,
#         color: color
#       )
#     end
#   end
# end

# # Ejecutar los seed
# seed_colors
# seed_categories
# seed_products