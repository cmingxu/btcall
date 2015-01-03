class Dashboard::SettingsController < Dashboard::BaseController
  def index
    @active_nav_item = "setting"
  end

  def create
    if current_user.latest_sms_notice.try(:param) != params[:sms_code].strip
      redirect_to dashboard_settings_path, :alert => "手机验证码不正确" and return
    end

    @user.mobile = params[:user][:mobile]
    @user.mobile_is_valid = true
    @user.latest_sms_notice.enter!
    if @user.save
      redirect_to dashboard_settings_path, :notice => "手机绑定成功" and return
    else
      redirect_to dashboard_settings_path, :notice => "手机绑定失败," + @user.errors.full_messages.first and return
    end
  end

  def send_sms
    @sms = current_user.sms_notices.build(:send_reason => params[:send_reason] || :verify,
                                          :param => "%04d" % rand(10000),
                                          :phone => params[:mobile],
                                         )

    if @sms.save
      Resque.enqueue_at Time.now, SendSms, @sms.id
      render :json => { :res => true }
    else
      render :json => { :res => false, :msg => @sms.errors.full_messages.last }
    end
  end
end

