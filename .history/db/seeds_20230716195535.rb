# db/seeds.rb

products = Product.all
colors = Color.all

# Verify products and colors
if products.present? && colors.present?
    products.each do |product|    
        random_color = colors.sample

    
    ProductColor.create!(
      product: product,
      color: random_color
    )
  end
else
  puts "No se encontraron productos o colores para crear la tabla product_colors."
end
