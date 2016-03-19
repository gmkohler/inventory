class Client < ActiveRecord::Base
  has_many :inventory_item_transactions
  has_many :inventory_items, -> { :distinct },
           through: :inventory_item_transactions
end
