class CreateOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :product, foreign_key: true
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
