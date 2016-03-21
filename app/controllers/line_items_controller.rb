class LineItemsController < ApplicationController
  def new
  end

  def create
    line_items = LineItem.new_collection(transaction_params, params[:line_items])

    all_saved = true
    line_items.each do |item|
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
