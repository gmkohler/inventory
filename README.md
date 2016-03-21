Inventory system where clients can have inventory items (e.g., spoons or
tablecloths) through a series of line-items, which can be thought of as transactions
that are specific to a single inventory item rather than an event or group of
inventory items.  A user can create clients, inventory items, and create
transactions between them.  Transactions can be scheduled for the future, the
present, or the past.

To run, `bundle install` the gems and execute `rake db:seed` for some basic
client and inventory item things built in.  Transactional data is left to user.

Using line items, a user can see all items at a given client, or all clients
with a given item.  The user can also look in the future or the past to see this
same information at an arbitrary.  To allow this, a piece of data is attached to
each line item that indicates a "running total", or best estimate of the count
of a good at a client based on a time series of transactional data.

Before validation, each of these `LineItem` models will find the "previous" `LineItem` with respect to `transaction_time`, and each subclass determines `self.running_total` in different ways.  The same idea of finding a "Previous" `LineItem` facilitates searching for an inventory at a given time.  After a `LineItem` is created, all LineItems of the same `client_id`/`inventory_item_id` combo and subsequent `transaction_times` are grabbed from the database, and the `running_total`s are updated in chronological order.


All `LineItem`s have a `type`, `quantity`, `transaction_time`, in addition to
the relations defined below.  After a new record is saved to the database,
a query will be made for all.

      class LineItem < ActiveRecord::Base
        LINE_ITEM_TYPES = ["Shipment", "Requirement", "StockTake"]

        after_create :update_subsequent_line_items!

        belongs_to :client
        belongs_to :inventory_item

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
      end

Each subclass of `LineItem` determines its running_count differently.  `Shipment`
adds to the count:

      class Shipment < LineItem
        before_validation :determine_running_count!, on: [:create]
        validates :quantity, numericality: { greater_than: 0 }

        def determine_running_count!(prev_item = nil)
          prev_item ||= LineItem.find_previous(self)
          prev_count = prev_item.nil? ? 0 : prev_item.running_count
          self.running_count = prev_count + self.quantity
        end
      end


`Requirement` would represent a sort of event at the client's premises only
detracts from the running count if the associated InventoryItem is reusable
(a boolean stored in the db).  A `Removal` could be implemented to represent a
process such as taking the reusable items to headquarters for cleaning.

      class Requirement < LineItem
        before_validation :determine_running_count!, on: [:create]
        validates :quantity, numericality: { greater_than: 0 }

        def determine_running_count!(prev_item = nil)
          prev_item ||= LineItem.find_previous(self)
          prev_ct = prev_item.nil? ? 0 : prev_item.running_count
          self.running_count = self.inventory_item.reusable? ? prev_ct : (prev_ct - self.quantity)
        end
      end

`StockTake` ignores previous values.  It represents a measured value and in
practice serves as a waypost for `Requirement` and `Shipment` extrapolations/estimates.

    class StockTake < LineItem
      before_validation :determine_running_count!, on: [:create]

      def determine_running_count!(prev_item = nil)
        self.running_count = self.quantity
      end
    end
