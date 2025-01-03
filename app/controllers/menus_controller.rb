class MenusController < ApplicationController
  layout "layouts/backend/app"
  before_action :set_menu, only: [:edit, :update]

  def index
    @menus = Menu.where(menu_fk: 0).order(id: :desc).page(params[:page]).per(3)
    @title = "Danh mục menu"
  end

  def new
    @menus = Menu.where(menu_fk: 0).all
    @menu = Menu.new
    @title = "Thêm menu"
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      redirect_to menus_path, notice: 'Menu was successfully created.'
    else
      @menus = Menu.where(menu_fk: 0).all
      @menu = Menu.new
      render :new
    end
  end

  def edit
    @menus = Menu.where(menu_fk: 0).all
    @title = "Sửa menu"
  end

  def update
    if @menu.update(menu_params)
      redirect_to menus_path, notice: 'Menu was successfully updated.'
    else
      @menus = Menu.where(menu_fk: 0).all
      @menu = Menu.new
      render :edit
    end
  end

  def delete
    @menu = Menu.find_by(id: params[:id])
    @menu.destroy
    redirect_to menus_path, notice: 'Menu was successfully destroyed.'
  end

  private
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :menu_fk, :slug)
    end

end
