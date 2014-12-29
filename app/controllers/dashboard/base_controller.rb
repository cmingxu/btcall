class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_filter :login_required

  def index
    @active_nav_item = "chart"
  end

  def sms_code_verify
    if params[:sms_code] != current_user.latest_sms_notice.param
      redirect_to :back, :notice => "手机验证码不正确" and return
    else
      current_user.latest_sms_notice.enter!
    end
  end
end
