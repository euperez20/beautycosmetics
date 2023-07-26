# db/seeds.rb

require 'faker'

products = Product.all

products.each do |product|
  product.update(price: Faker::Number.decimal(l_digits: 2, r_digits: 2))
end
