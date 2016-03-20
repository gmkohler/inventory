class InventoryItem < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :line_items
  has_many :clients, -> { distinct },
           through: :line_items,
           dependent: :destroy
 def self.ids_and_names
   self.pluck_to_hash(:id, :name).sort {|a, b| a[:name] <=> b[:name]}
 end
end
