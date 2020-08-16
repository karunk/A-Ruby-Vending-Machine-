class CreateProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
