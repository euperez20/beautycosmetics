class AddTotalAmountWithTaxesToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :total_amount_with_taxes, :decimal, precision: 10, scale: 2
  end
end
