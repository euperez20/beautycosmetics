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
