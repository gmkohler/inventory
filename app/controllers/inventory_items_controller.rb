class InventoryItemsController < ApplicationController
  def new
    @inv_item = InventoryItem.new
  end

  def create
    @inv_item = InventoryItem.new(inventory_params)
    if @inv_item.save
      flash[:success] = "Inventory Item successfully created"
      redirect_to inventory_item_url(@inv_item)
    else
      flash.now[:errors] = @inv_item.errors.full_messages
      render :new
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
    params.require(:inventory_item).permit(:type, :name, :description, :reusable)
  end
end
