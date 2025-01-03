class ProductsController < ApplicationController
  layout 'layouts/backend/app'
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    query = params[:table_search].to_s.strip
    
    @products = Product.all
    @products = @products.where("name LIKE ?", "%#{query}%") if query.present?
  
    @inventory = params[:inventory].to_s.strip.presence || "Còn hàng"
  
    case @inventory
    when "Còn hàng"
      @products = @products.where("inventory_count > 0")
    when "Hết hàng"
      @products = @products.where("inventory_count <= 0")
    end
  
    @per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
  
    @products = @products.order(id: :desc).page(params[:page]).per(@per_page)
  
    @title = "Danh mục sản phẩm"
  end
  
  
  

  def show
    # @product = Product.find(params[:id])
    @product.increment!(:view)
  end

  def new
    @product = Product.new
    @menus = Menu.where(menu_fk: 0).or(Menu.where(menu_fk: nil))
    @title = "Thêm sản phẩm"
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_url, notice: 'Product was successfully created.'
    else
      alert = @product.errors.full_messages.to_sentence
      flash.now[:alert] = alert
      @menus = Menu.where(menu_fk: 0).or(Menu.where(menu_fk: nil))
      @product = Product.new
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @product = Product.find(params[:id])
    @menus = Menu.where(menu_fk: 0).or(Menu.where(menu_fk: nil))
    @title = "Sửa sản phẩm"
  end

  def update
    # @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to products_url, notice: 'Product was successfully updated.'
    else
      alert = @product.errors.full_messages.to_sentence
      flash.now[:alert] = alert
      @menus = Menu.where(menu_fk: 0).or(Menu.where(menu_fk: nil))
      @product = Product.new
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url
  end

  def delete
    @product = Product.find_by(id: params[:id])
    @product.destroy if @product
    redirect_to products_url 
  end

  private
    def product_params
      params.expect(product: [ :name, :description, :featured_image, :inventory_count, :menu_id, :price, :discount, :slug ])
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
