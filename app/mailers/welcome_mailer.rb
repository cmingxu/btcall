class WelcomeMailer < ActionMailer::Base
  default from: Settings.default_email_sender


  def activation_email(user)
    @user = user
    mail(to: user.email, subject: "您刚刚用Email#{user.email}注册了#{Settings.site_name}的服务，请您激活 ")
  end

  def forget_password_email(user)
    @user = user
    mail(to: user.email, subject: "您刚刚重置#{Settings.site_name}的密码 ")
  end
end
