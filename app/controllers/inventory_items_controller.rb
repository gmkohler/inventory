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
    # params[:time] can be nil, in which case the LineItem function will default
    # to `today`
    @time = params[:time]
    @inv_item = InventoryItem.find(params[:id])
    @line_items = LineItem.get_clients_for_inventory_item(params[:id], @time)
  end

  private
  def inventory_params
    params.require(:inventory_item).permit(:type, :name, :description, :reusable)
  end
end
