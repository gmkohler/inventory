class InventoryItem < ActiveRecord::Base
  has_many :inventory_item_transactions
  has_many :clients, -> {:distinct},
           through: :inventory_item_transactions

end
