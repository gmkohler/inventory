class CreateInventoryItemTransactions < ActiveRecord::Migration
  def change
    create_table :inventory_item_transactions do |t|
      t.string :type, null: false
      t.integer :client_id, null: false
      t.integer :inventory_item_id, null: false
      
      t.datetime :transaction_time, null: false
      t.integer :running_count, null: false
      t.timestamps null: false
    end
  end
end
