class Shipment < LineItem
  before_validation :determine_running_count!, on: [:create]

  def determine_running_count!(prev_item = nil)
    prev_item ||= LineItem.find_previous(self)
    prev_count = prev_item.nil? ? 0 : prev_item.running_count
    self.running_count = prev_count += self.quantity
  end
end
