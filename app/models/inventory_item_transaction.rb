class InventoryItemTransaction < ActiveRecord::Base
  before_create :determine_running_total!
  after_create :update_subsequent_transactions!

  validates :type, inclusion: ["Shipment", "Requirement", "StockTake"]
  validates :client, :inventory_item, :quantity, :running_total, presence: true
  belongs_to :client
  belongs_to :inventory_item

  def self.find_subsequent_transactions(txn)
    # using #gteq to include `txn` in the return.  Makes the iteration in
    # update_subsequent_transactions! more straightforward
    self.where(
      InventoryItemTransaction.arel_table[:transaction_time]
                              .gteq(txn.transaction_time),
      client: txn.client,
      inventory_item: txn.inventory_item
    ).order(transaction_time: :asc)
  end

  def self.find_previous_transaction(txn)
    self.where(
      InventoryItemTransaction.arel_table[:transaction_time]
                              .lteq(txn.transaction_time),
      client: txn.client,
      inventory_item: txn.inventory_item
    ).order(transaction_time: :asc)
     .take(1)
  end

  def update_subsequent_transactions!
    future_txns = InventoryItemTransaction.find_subsequent_transactions(self)
    # by calling .drop(1) and offsetting the index, we won't call
    # determine_running_total! on self, which will have happened during
    # the before_create lifecycle method.
    future_txns.drop(1).each.with_index do |txn, j = 1|
      txn.determine_running_total!(future_txns[j-1])
    end
    future_txns.update!
  end

  def determine_running_total!
    # implemented by inherited models
  end
end
