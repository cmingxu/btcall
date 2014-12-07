class SessionController < ApplicationController
  before_filter :no_login_required, :except => :logout
  before_filter :validate_captcha, :only => [:login, :register]

  def login
    store_request_path
    if request.post?
      if @user = User.login(user_params)
        session[:user_id] = @user.id
        redirect_to dashboard_path, notice: "欢迎回来，#{@user.login || @user.email}"
      else
        redirect_to login_path, alert: "用户名密码不正确， 或者您尚未激活账号."
      end
    end
  end

  def register
    store_request_path
    @user = User.new

    if request.post?
      @user = User.new(user_params)
      if @user.save
        redirect_to register_path, notice: "您已经成功注册为本站会员， 一封激活邮件已经发送到#{@user.email}, 请您查收"
      else
        redirect_to register_path, alert: @user.errors[:email].first
      end
      return
    end
  end

  def logout
    session.delete[:user_id]
  end

  def user_params
    params[:user].permit(:email, :password, :password_confirmation, :captcha)
  end

  def validate_captcha
    return true if request.get?

    ap user_params

    if !valid_captcha?(user_params[:captcha])
      redirect_to :back, alert: "您输入的验证码有误" and return false
    end
  end
end
