class LineItem < ActiveRecord::Base
  LINE_ITEM_TYPES = ["Shipment", "Requirement", "StockTake"]

  after_create :update_subsequent_line_items!

  validates :type, inclusion: LINE_ITEM_TYPES
  validates :client, :inventory_item, :running_count, :quantity, presence: true
  validates :running_count, numericality: true
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :client
  belongs_to :inventory_item

  def self.types
    LINE_ITEM_TYPES
  end

  def self.new_collection(transaction_params, line_item_params)
    line_item_params.map do |item_data|
      self.new(transaction_params.merge(item_data))
    end
  end

  def self.get_inventory_items_for_client(client_id, txn_time = nil )
    txn_time ||= DateTime.now
    # gets most recent transaction for each inventory item of a given client
    self.includes(:inventory_item)
        .select("DISTINCT ON (inventory_item_id) line_items.*")
        .where(
          "transaction_time < ? AND client_id = ?", txn_time, client_id
        ).order(inventory_item_id: :asc, transaction_time: :desc)
  end

  def self.get_clients_for_inventory_item(inventory_item_id, txn_time = nil)
    txn_time ||= DateTime.now
    # gets most recent transaction for each inventory item of a given client
    self.includes(:client)
        .select("DISTINCT ON (client_id) line_items.*")
        .where(
          "transaction_time < ? AND inventory_item_id = ?",
          txn_time,
          inventory_item_id
        ).order(client_id: :asc, transaction_time: :desc)
  end

  def self.find_subsequents(line_item)
    self.where(
      LineItem.arel_table[:transaction_time].gt(line_item.transaction_time),
      client: line_item.client,
      inventory_item: line_item.inventory_item
    ).order(transaction_time: :asc)
  end

  def self.find_previous(line_item)
    self.where(
      LineItem.arel_table[:transaction_time].lteq(line_item.transaction_time),
      client: line_item.client,
      inventory_item: line_item.inventory_item
    ).order(transaction_time: :asc)
     .first
  end

  def update_subsequent_line_items!
    future_line_items = LineItem.find_subsequents(self)
    # make the concatenated array so `future_line_items[0]` can reference `self`
    # in the iteration
    line_items_array = [self].concat(future_line_items)
    future_line_items.each.with_index do |line_item, j|
      line_item.determine_running_count!(line_items_array[j])
      line_item.update({running_count: line_item.running_count})
    end
  end

  def determine_running_count!(prev_item = nil)
    # implemented by inherited models
  end
end
