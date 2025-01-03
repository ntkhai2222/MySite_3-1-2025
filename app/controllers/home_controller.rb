class HomeController < ApplicationController
  allow_unauthenticated_access
  layout 'layouts/frontend/app'

  def index
    @products_giam_gia = Product.where(menu_id: 10)
                                .or(Product.where(menu_id: Menu.where(menu_fk: 10).pluck(:id)))
                                .or(Product.where("discount > ?", 0))
                                .order(id: :desc)
                                .limit(4)

    @products_new = Product.order(id: :desc).limit(8)

    @products_view = Product.order(view: :desc).limit(8)

    child_menu_sn_ids = Menu.where(menu_fk: 1).pluck(:id)
    @products_sinh_nhat = Product.where(menu_id: [1, *child_menu_sn_ids]).order(id: :desc).limit(4)

    child_menu_kt_ids = Menu.where(menu_fk: 5).pluck(:id)
    @products_khai_truong = Product.where(menu_id: [5, *child_menu_kt_ids]).order(id: :desc).limit(8)

    child_menu_hl_ids = Menu.where(menu_fk: 6).pluck(:id)
    @products_hoa_lan = Product.where(menu_id: [6, *child_menu_hl_ids]).order(id: :desc).limit(8)

    @banners = Banner.where(active: 1).order(:item)
  end


  def detail
    @product = Product.find(params[:id])
    @product.increment!(:view)
    menu = Menu.includes(:children).find(@product.menu_id)

    menu_ids = [menu.id]
    menu_ids += menu.children.pluck(:id) if menu.children.present?

    @products = Product.where(menu_id: menu_ids)
                       .where.not(id: @product.id)
                       .order(id: :desc)
                       .limit(4)

    @top_view_products = Product.where.not(id: @product.id).order(view: :desc).limit(4)
  end

  def menu_products
    @menu = Menu.includes(:children).find(params[:id])
    menu_ids = [@menu.id] + @menu.children.pluck(:id)

    @products = Product.where(menu_id: menu_ids).order(id: :desc).page(params[:page]).per(20)
  end

  def page_detail
    @page = Page.find_by(slug: params[:slug])
    if @page.nil?
      redirect_to root_path, alert: "Page not found!"
    end
  end

  def search
    @q = params[:q].to_s.strip
    @per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
  
    @sort = params[:sort].to_s.strip || "Mặc định"
    
    order_query = case @sort
                  when "Tên (A - Z)"
                    "name ASC"
                  when "Tên (Z - A)"
                    "name DESC"
                  when "Giá (Thấp - Cao)"
                    "price DESC"
                  when "Giá (Cao - Thấp)"
                    "price ASC"
                  else
                    "id DESC"
                  end
  
    @products = Product.where("name LIKE ?", "%#{@q}%")
                       .order(order_query)
                       .page(params[:page])
                       .per(@per_page)
  end
  
  
  def register
    @user = User.new
  end

  def customer_register
    if User.exists?(email_address: user_params[:email_address])
      flash.now[:alert] = 'Email đã tồn tại. Vui lòng sử dụng một email khác.'
      @user = User.new
      render :register
    else
      @user = User.new(user_params)
      @user.super_user ||= 2
      if @user.save
        redirect_to home_login_path, notice: 'Người dùng đã được tạo thành công.'
      else
        alert = @user.errors.full_messages.to_sentence
        flash.now[:alert] = alert
        @user = User.new
        render :register
      end
    end
  end

  def customer_login
    if user = User.authenticate_by(params.permit(:email_address, :password))
      if user.super_user == 2
        session[:user_id] = user.id

        if session[:cart] && session[:cart].any?
          session[:cart].each do |product_id, quantity|
            Cart.create(
              user_id: user.id,
              product_id: product_id.to_i,
              quantity: quantity.to_i
            )
          end
  
          session[:cart] = nil
        end
        redirect_to account_index_path
      end
    else
      redirect_to home_login_path, alert: "Try another email address or password."
    end
  end

  def customer_logout
    reset_session
    session[:cart] = nil
    redirect_to home_index
  end


  private

    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation, :name, :phone)
    end
    
end
