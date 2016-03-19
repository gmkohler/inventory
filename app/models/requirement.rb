class Requirement < InventoryItemTransaction
  def determine_running_total!(prev_txn)
    prev_txn ||= InventoryItemTransaction.find_previous_transaction(self)
    self.running_total = prev_txn.quantity -= self.quantity
  end
end
