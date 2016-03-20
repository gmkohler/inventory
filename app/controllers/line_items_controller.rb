class LineItemsController < ApplicationController
  def new
  end
  def create
    all_saved = true
    items = params[:line_items].each do |data|
      item = LineItem.new(transaction_params)
      data.each {|key, value| item.send("#{key}=", value)}

      unless item.save
        all_saved = false
        error_msgs = item.errors.full_messages
        break
      end
    end

    if all_saved
      flash[:success] = "Transaction Logged!"
      redirect_to client_url(transaction_params[:client_id])
    else
      flash.now[:errors] = error_msgs
      render :new
    end


  end
  private
  def transaction_params
    params.require(:transaction).permit(:type, :client_id, :transaction_time)
  end
end
