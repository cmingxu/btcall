class Dashboard::WithdrawAddressesController < Dashboard::BaseController
  before_filter :sms_code_verify, :only => :create
  def index
    @active_nav_item = "withdraws"
    @withdraw_addresses = current_user.withdraw_addresses
  end

  def create
    @withdraw_address = current_user.withdraw_addresses.new(address_params)
    if @withdraw_address.save
      notice = "新地址添加成功"
      redirect_to dashboard_withdraw_addresses_path, :alert => notice
    else
      notice = @withdraw_address.errors.full_messages.first
      redirect_to dashboard_withdraw_addresses_path, :notice => notice
    end
  end

  def address_params
    params[:withdraw_address].permit(:label, :btcaddress)
  end
end
