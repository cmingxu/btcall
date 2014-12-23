class ApplicationController < ActionController::Base
  include HelperUtils
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!
  before_filter :set_active_sidebar_item

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def admin_required
    current_user && current_user.admin?
  end

  def login_required
    if(!current_user)
      redirect_to root_path and return false
    end
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

  def set_active_sidebar_item
    @active_nav_item  = controller_name
  end
end
