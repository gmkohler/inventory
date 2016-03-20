class ChangeInventoryItemReusableDefault < ActiveRecord::Migration
  def change
    change_column_default(:inventory_items, :reusable, false)
  end
end
