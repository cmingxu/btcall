class SessionController < ApplicationController
  layout "session"

  before_filter :no_login_required, :except => :logout
  before_filter :validate_captcha, :only => [:login, :register, :forget_password, :reset_password], :if => lambda { !request.get? }

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
        send_email do WelcomeMailer.activation_email(@user).deliver; end
        redirect_to register_path, notice: "您已经成功注册为本站会员， 一封激活邮件已经发送到#{@user.email}, 请您查收"
      else
        redirect_to register_path, alert: @user.errors.messages.values.flatten.first
      end
      return
    end
  end

  def activation
    @user = User.find_by_activation_code(params[:activation_code])
    if @user
      @user.active!
      redirect_to login_path, :notice => "成功激活您的#{Settings.cn_site_name}账号， 请登录"
    else
      redirect_to login_path, :notice => "激活失败"
    end
  end

  def logout
    session.delete( :user_id )
    redirect_to root_path
  end

  def forget_password
    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user
        @user.forget_password!
        send_email do WelcomeMailer.forget_password_email(@user).deliver; end
        redirect_to forget_password_path, :alert => "一封找回密码邮件已经发送到您的邮箱里了"
      else
        redirect_to forget_password_path, :alert => "您输入的email还未注册！"
      end
      return
    end
  end

  def reset_password
    @user = User.find_by_reset_password_token(params[:reset_password_token])
    if !@user
      flash.now[:alert] = "重置密码失败"
      render and return
    end

    if request.post? && params[:user][:password].length >= 6
      @user.password = params[:user][:password]
      @user.reset_password_token = ""
      @user.save
      redirect_to login_path, :notice => "密码重置成功请登陆"
    end
  end

  def user_params
    params[:user].permit(:email, :password, :password_confirmation, :captcha, :reset_password_token)
  end

  def validate_captcha
    return true if request.get?

    if !valid_captcha?(user_params[:captcha])
      redirect_to :back, alert: "您输入的验证码有误" and return false
    end
  end
end
