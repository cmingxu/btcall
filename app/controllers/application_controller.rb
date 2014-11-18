class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def admin_required
    true
  end

  def login_required
    true
  end

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_login_in?
    !!current_user
  end

  def no_login_required
    redirect_to dashboard_path, :notice => "您已经登陆， 不需要重新登陆" if  user_login_in?
  end

  def store_request_path
    session[:redirect_to] = params[:redirect_to] || request.referer
  end
end
