class AddHstToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :hst, :decimal, precision: 10, scale: 2
  end
end
