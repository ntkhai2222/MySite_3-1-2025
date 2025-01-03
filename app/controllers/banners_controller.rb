class BannersController < ApplicationController
  layout "layouts/backend/app"
  before_action :set_banner, only: %i[edit update delete]

  def index
    @banners = Banner.order(:item).page(params[:page]).per(10)
    @title = "Danh mục banner"
  end

  def new
    @banner = Banner.new
    @title = "Thêm banner"
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to banners_path, notice: 'Banner was successfully created.'
    else
      @banner = Banner.new
      render :new
    end
  end


  def edit
    @title = "Sửa banner"
  end

  def update
    if @banner.update(banner_params)
      redirect_to banners_path, notice: 'Banner was successfully updated.'
    else
      @banner = Banner.new
      render :edit
    end
  end

  def delete
    @banner.destroy
    redirect_to banners_url, notice: 'Banner was successfully destroyed.'
  end

  private
    def set_banner
      @banner = Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:name, :item, :active, :link, :slug, :featured_image)
    end
end
