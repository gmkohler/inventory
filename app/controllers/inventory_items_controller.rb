class InventoryItemsController < ApplicationController

  def create
    @inv_item = InventoryItem.new(inventory_params)
    if @inv_item.save

    else

    end
  end

  def index
    @inv_items = InventoryItem.all
  end

  def show
    @inv_item = InventoryItem.includes(:clients).find(params[:id])
  end

  private
  def inventory_params
    params.require(:inventory_item).permit(:type, :name, :description)
  end
end
