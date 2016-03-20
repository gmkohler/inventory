class InventoryItem < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :line_items
  has_many :clients, -> { distinct },
           through: :line_items,
           dependent: :destroy
end
