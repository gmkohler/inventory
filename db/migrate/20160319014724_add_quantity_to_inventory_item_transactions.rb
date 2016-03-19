class AddQuantityToInventoryItemTransactions < ActiveRecord::Migration
  def change
    add_column :inventory_item_transactions, :quantity, :integer
  end
end
