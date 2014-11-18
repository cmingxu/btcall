class SessionController < ApplicationController
  before_filter :no_login_required, :except => :logout

  def login
    store_request_path
    if request.post?
      if @user = User.login(user_params)
        session[:user_id] = @user.id
        redirect_to dashboard_path
      end
    end
  end

  def register
    store_request_path
    @user = User.new

    if request.post?
      @user = User.new(user_params)
      if @user.save
        redirect_to root_path
      else
        redirect_to register_path, notice: @user.errors[:email].first
      end
      return
    end
  end

  def logout
    session.delete[:user_id]
  end

  def user_params
    params[:user].permit(:email)
  end
end
