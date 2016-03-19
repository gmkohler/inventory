class StockTake < InventoryItemTransaction
  def determine_running_total!(prev_txn)
    self.running_total = self.quantity
  end
end
