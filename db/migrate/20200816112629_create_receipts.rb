class CreateReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :receipts do |t|
      t.references :order, foreign_key: true
      t.float :bill, null: false
      t.float :cash_given, null: false
      t.float :balance_returned, default: 0
      t.timestamps
    end
  end
end
