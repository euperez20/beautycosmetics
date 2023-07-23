class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_reference :users, :province, null: false, foreign_key: true
  end
end
