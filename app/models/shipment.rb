class Shipment < InventoryItemTransaction
  def determine_running_total!(txn)
    txn ||= InventoryItemTransaction.find_previous_transaction(self)
    self.running_total = txn.quantity += self.quantity
  end
end
