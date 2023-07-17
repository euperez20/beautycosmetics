# db/seeds.rb

products = Product.all
colors = Color.all

# Verif
if products.present? && colors.present?
  # Iterar sobre todos los productos y asociarles colores aleatorios
  products.each do |product|
    # Obtener un color aleatorio de la lista de colores
    random_color = colors.sample

    # Crear el registro en la tabla product_colors para asociar el color al producto
    ProductColor.create!(
      product: product,
      color: random_color
    )
  end
else
  puts "No se encontraron productos o colores para crear la tabla product_colors."
end
