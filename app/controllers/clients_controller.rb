class ClientsController < ApplicationController
  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      flash[:success] = "Client successfully created!"
      redirect_to client_url(@client)
    else
      flash.now[:errors] = @client.errors.full_messages
      render :new
    end
  end

  def index
    @clients = Client.all.order(:name)
  end

  def show
    @client = Client.find(params[:id])
    @line_items = LineItem.get_inventory_items_for_client(@client)
  end

  private
  def client_params
    params.require(:client).permit(:name)
  end

end
