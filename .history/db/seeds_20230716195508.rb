# db/seeds.rb

products = Product.all
colors = Color.all

# Verify products and colors
if products.present? && colors.present?
    products.each do |product|
    z
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
