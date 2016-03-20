class AddNameToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :name, :string
  end
end
