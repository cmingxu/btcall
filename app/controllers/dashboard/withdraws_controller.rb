class Dashboard::WithdrawsController < Dashboard::BaseController
  def index
    @withdraws = current_user.withdraws.page params[:page]
  end

  def create
    @withdraw = current_user.withdraws.new(withdraw_params)
    if @withdraw.save
      notice = "提现请求成功， 请稍后查看您的入账账号"
      redirect_to dashboard_withdraws_path, :notice => notice
    else
      notice = @withdraw.errors.full_messages.first
      redirect_to dashboard_withdraws_path, :alert => notice
    end

  end

  def withdraw_params
    params[:withdraw].permit(:withdraw_address_id, :amount_decimal)
  end
end
