class CartController < ApplicationController
  allow_unauthenticated_access
  layout 'layouts/frontend/app'

  def index
    
  end

  def add
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
  
    if current_user
      cart_item = Cart.find_or_initialize_by(user_id: current_user.id, product_id: product_id)
      cart_item.quantity = cart_item.quantity.to_i + quantity
      cart_item.save
    else
      session[:cart] ||= {}
      cart = session[:cart]
  
      if cart[product_id]
        cart[product_id] += quantity
      else
        cart[product_id] = quantity
      end
  
      session[:cart] = cart
    end
  
    redirect_back(fallback_location: home_login_path, notice: "Sản phẩm đã được thêm vào giỏ hàng!")
  end
  

  def remove
    key = params[:key].to_s
  
    if current_user
      cart_item = Cart.find_by(user_id: current_user.id, product_id: key)
  
      if cart_item
        cart_item.destroy
      end
    else
      cart = session[:cart] || {}
  
      if cart.key?(key)
        cart.delete(key)
      end
  
      session[:cart] = cart
    end
  
    redirect_back(fallback_location: home_login_path, notice: 'Sản phẩm đã được xóa khỏi giỏ hàng!')
  end
  

  def update
    key = params[:key].to_s

    if current_user
      cart_item = Cart.find_by(user_id: current_user.id, product_id: key)
  
      if cart_item
        cart_item.quantity = params[:quantity].to_i
        cart_item.save
      end
    else
      cart = session[:cart] || {}
  
      if cart.key?(key)
        cart[key] = params[:quantity].to_i
      end
  
      session[:cart] = cart
    end

    redirect_back(fallback_location: home_login_path, notice: 'Giỏ hàng đã được cập nhật!')
  end

  def checkout
    if cart_items.empty?
      redirect_to cart_index_path
      return
    end
    @order = Order.new
  end

  def pay
    ActiveRecord::Base.transaction do
      shipping_date = Date.parse(params[:shipping_date])
      if shipping_date <= Date.today
        raise StandardError, "Ngày giao hàng phải lớn hơn ngày hôm nay!"
      end

      # kiểm tra số lượng sp trong kho
      cart_items.each do |item|
        product = Product.find(item[:id])
        if product.inventory_count < item[:quantity].to_i
          raise StandardError, "Sản phẩm #{product.name} không đủ số lượng trong kho! Hiện tại chỉ còn #{product.inventory_count} sản phẩm."
        end
      end
  
      order = Order.create!(
        name: params[:name],
        phone: params[:phone],
        email: params[:email],
        shipping_name: params[:shipping_name],
        shipping_phone: params[:shipping_phone],
        shipping_address: params[:shipping_address],
        shipping_date: params[:shipping_date],
        shipping_time: params[:shipping_time],
        shipping_mess: params[:shipping_mess],
        shipping_note: params[:shipping_note],
        discount: params[:discount],
        order_total: params[:order_total],
        status: 'pending'
      )
  
      cart_items.each do |item|
        order_detail = order.order_details.create!(
          name: item[:name],
          quantity: item[:quantity],
          price: item[:price]
        )
  
        product = Product.find(item[:id])
        if product.featured_image.attached?
          image_file = product.featured_image.download
          order_detail.featured_image.attach(io: StringIO.new(image_file), filename: "#{item[:name]}_featured_image.jpg")
        end
  
        product.update!(inventory_count: product.inventory_count - item[:quantity].to_i)
      end
    end
  
    if current_user
      Cart.where(user_id: current_user.id).destroy_all
    else
      session[:cart] = nil
    end
  
    redirect_to cart_thanh_you_path
  rescue StandardError => e
    flash[:alert] = "Có lỗi xảy ra: #{e.message}"
    redirect_to cart_checkout_path
  end
  
end