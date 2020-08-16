class CreateDenominations < ActiveRecord::Migration[6.0]
  def change
    create_table :denominations do |t|
      t.string :change_type, null: false, unique: true
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
