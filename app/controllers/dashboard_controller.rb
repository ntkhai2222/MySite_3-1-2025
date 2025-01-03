class DashboardController < ApplicationController
  layout "layouts/backend/app"

  def index
    @noidung = "Nội dung bài viết"
    @title = "Dashboard"
  end
end
