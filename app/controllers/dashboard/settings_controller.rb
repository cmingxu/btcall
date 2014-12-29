class Dashboard::SettingsController < Dashboard::BaseController
  def index
  end

  def send_sms
    @sms = current_user.sms_notices.build(:send_reason => :verify,
                                          :params => "%04d" % rand(10000)
                                         )

    if @sms.save
      render :json => {}
    else
      render :json => {:res => false}, :status => 402
    end
  end
end

