class CreateColors < ActiveRecord::Migration[7.0]
  def change
    create_table :colors do |t|
      t.string :hex_value
      t.string :color_name

      t.timestamps
    end
  end
end
