class PagesController < ApplicationController
  layout 'layouts/backend/app'
  before_action :set_page, only: %i[edit update delete]

  def index
    @pages = Page.all
    @title = "Danh mục page"
  end

  def new
    @page = Page.new
    @title = "Thêm page"
  end

  def edit
    @title = "Sửa page"
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to pages_path, notice: 'Page was successfully created.'
    else
      @page = Page.new
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      redirect_to pages_path, notice: 'Page was successfully updated.'
    else
      @page = Page.new
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
    @page.destroy
    redirect_to pages_url, notice: 'Page was successfully destroyed.'
  end

  private

    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:name, :description, :slug)
    end

end
