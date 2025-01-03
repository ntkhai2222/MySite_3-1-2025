class ApplicationController < ActionController::Base
  include Authentication

  around_action :switch_locale
  before_action :set_data

  helper_method :current_user

  helper_method :cart_items

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end


  private

  def set_data
    @menuTree = Menu.includes(:children).where(menu_fk: 0).all
    @pages = Page.all
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_customer!
    redirect_to home_login_path, alert: "Bạn cần đăng nhập để tiếp tục." unless current_user
  end

  def cart_items
    if current_user
      cart = Cart.where(user_id: current_user.id)
  
      product_ids = cart.pluck(:product_id)
      products = Product.where(id: product_ids)
  
      items = products.map do |product|
        cart_item = cart.find { |item| item.product_id == product.id }
  
        {
          id: product.id,
          name: product.name,
          price: product.discount > 0 ? product.price.to_f - (product.discount / 100.0 * product.price.to_f) : product.price.to_f,
          quantity: cart_item.quantity, 
          image: product.featured_image,
          slug: product.slug
        }
      end
    else
      cart = session[:cart] || {}
  
      product_ids = cart.keys
      products = Product.where(id: product_ids)
  
      items = products.map do |product|
        {
          id: product.id,
          name: product.name,
          price: product.discount > 0 ? product.price.to_f - (product.discount / 100.0 * product.price.to_f) : product.price.to_f,
          quantity: cart[product.id.to_s],
          image: product.featured_image,
          slug: product.slug
        }
      end
    end
  
    items
  end
  
end
