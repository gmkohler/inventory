class Client < ActiveRecord::Base
  has_many :line_items
  has_many :inventory_items, -> { distinct }, through: :line_items
end
