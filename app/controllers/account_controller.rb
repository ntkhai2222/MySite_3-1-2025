class AccountController < ApplicationController
  allow_unauthenticated_access
  layout 'layouts/frontend/app'
  before_action :authenticate_customer!
  before_action :set_user, only: [:edit, :update, :password, :password_update]

  def index

  end

  def edit

  end

  def update
    if @user.update(user_params_edit)
      redirect_to account_index_path, notice: 'Thông tin người dùng đã được cập nhật.'
    else
      alert = @user.errors.full_messages.to_sentence
      flash.now[:alert] = alert
      @user = User.new
      render :edit
    end
  end

  def password

  end

  def password_update
    if @user.update(user_params_edit_password)
      redirect_to account_index_path, notice: 'Mật khẩu đã thay đổi.'
    else
      alert = @user.errors.full_messages.to_sentence
      flash.now[:alert] = alert
      @user = User.new
      render :password
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to home_logout_path
  end

  private
    def set_user
      @user = current_user 
    end

    def user_params_edit
      params.require(:user).permit(:email_address, :name, :phone)
    end

    def user_params_edit_password
      params.require(:user).permit(:password, :password_confirmation)
    end
end