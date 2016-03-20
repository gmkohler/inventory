class InventoryItem < ActiveRecord::Base
  has_many :line_items
  has_many :clients, -> { distinct }, through: :line_items
end
