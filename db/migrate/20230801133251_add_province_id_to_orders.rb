class AddProvinceIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :province_id, :integer
  end
end
