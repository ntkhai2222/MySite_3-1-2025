class SessionsController < ApplicationController
  layout 'layouts/backend/appAdmin'
  allow_unauthenticated_access only: %i[ new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    
    if user
      if user.super_user != 2
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: "Try another email address or password."
      end
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end
  

  def logout
    terminate_session
    redirect_to new_session_path
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || dashboard_path
  end
end
