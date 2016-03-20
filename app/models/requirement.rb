class Requirement < LineItem
  before_validation :determine_running_count!, on: [:create]
  validates :quantity, numericality: { greater_than: 0 }

  def determine_running_count!(prev_item = nil)
    prev_item ||= LineItem.find_previous(self)
    prev_ct = prev_item.nil? ? 0 : prev_item.running_count
    self.running_count = self.inventory_item.reusable? ? prev_ct : (prev_ct - self.quantity)
  end
end
