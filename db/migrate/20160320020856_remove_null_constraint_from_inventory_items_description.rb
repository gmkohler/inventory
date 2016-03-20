class RemoveNullConstraintFromInventoryItemsDescription < ActiveRecord::Migration
  def change
    remove_column :inventory_items, :description, :string
    add_column :inventory_items, :description, :string
  end
end
