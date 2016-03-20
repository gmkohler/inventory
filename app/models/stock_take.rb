class StockTake < LineItem
  before_validation :determine_running_count!, on: [:create]
  
  def determine_running_count!(prev_item = nil)
    self.running_count = self.quantity
  end
end
