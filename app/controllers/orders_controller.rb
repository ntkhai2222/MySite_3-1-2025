class OrdersController < ApplicationController
  layout "layouts/backend/app"

  # def index
  #   @orders = Order.all
  #   @title = "Đơn đặt hàng"
  # end

  def index
    query = params[:table_search].to_s.strip
    
    @orders = Order.all
  
    if query.present?
      search_query = "%#{query}%"
      columns = [:name, :email, :phone, :shipping_name, :shipping_phone, :shipping_address]
      conditions = columns.map { |column| "#{column} LIKE :query" }.join(" OR ")
      @orders = @orders.where(conditions, query: search_query)
    end
  
    @status = params[:status].to_s.strip.presence || "Chưa duyệt"
    case @status
    when 'Chưa duyệt'
      @orders = @orders.where(status: 'pending')
    when 'Đã duyệt'
      @orders = @orders.where(status: 'approved')
    when 'Đã hủy'
      @orders = @orders.where(status: 'cancelled')
    end

    @orders = @orders.where(shipping_date: params[:shipping_date]) if params[:shipping_date].present?
  
    @per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
  
    @orders = @orders.order(id: :desc).page(params[:page]).per(@per_page)
  
    @title = "Đơn đặt hàng"
  end
  

  def show
    @order = Order.includes(:order_details).find(params[:id])

    @title = "Chi tiết đơn hàng"
  end

  def update_status
    order = Order.find(params[:id])
    order.update(status: params[:status])
    redirect_to orders_path, notice: params[:status] == "approved" ? "Duyệt đơn hàng thành công!" : "Hủy đơn hàng thành công!"
  end

  def delete
    Order.find(params[:id]).destroy
    redirect_to orders_path, notice: "Xóa đơn hàng thành công!"
  end
end
