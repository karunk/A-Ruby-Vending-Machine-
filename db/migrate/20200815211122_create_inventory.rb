class CreateInventory < ActiveRecord::Migration[6.0]
  def change
    create_table :inventories do |t|
      t.integer :available, default: 0
      t.integer :reserved, default: 0
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
