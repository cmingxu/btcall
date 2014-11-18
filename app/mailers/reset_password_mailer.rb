class ResetPasswordMailer < ActionMailer::Base
  default from: Settings.default_email_sender

  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: "重新设置您的登录密码 ")
  end

  def for_the_first_time_reset_password_fo(user)
    @user = user
    mail(to: @user.email, subject: "欢迎您使用Btcall的服务， 请设置您的登陆密码")
  end

end
