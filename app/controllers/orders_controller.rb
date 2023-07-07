class OrdersController < ApplicationController
  before_action :select_item, only: [:index, :create]
  before_action :authenticate_user!, only: [:index]

  def index
    return redirect_to root_path if current_user.id = @item.user.id
    @order_address = OrderAddress.new
    # @orders = Order.all
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id])
  end

  def select_item
    @item = Item.find(params[:item_id])
  end
  
end
