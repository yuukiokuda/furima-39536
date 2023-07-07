class OrdersController < ApplicationController
  before_action :select_item, only: [:index, :create]
  before_action :authenticate_user!, only: [:index]
  before_action :set_public_key, only: [:index, :create]

  def index
    return redirect_to root_path if current_user.id == @item.user.id
    @order_address = OrderAddress.new
    # @orders = Order.all
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture, :city, :addresses, :building, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id],token: params[:token])
  end

  def select_item
    @item = Item.find(params[:item_id])
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]  # 自身のPAY.JPテスト秘密鍵を記述しましょう
    Payjp::Charge.create(
      # binding.pry
      amount: @item.price,  # 商品の値段
      card: order_params[:token],    # カードトークン
      currency: 'jpy'                 # 通貨の種類（日本円）
    )
  end

  def set_public_key
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"] #JavaScriptに渡すため変数設定
end
  
end
