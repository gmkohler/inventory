class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.string :type
      t.string :description, null: false, unique: true
      t.boolean :reusable, default: true
      
      t.timestamps null: false
    end
  end
end
