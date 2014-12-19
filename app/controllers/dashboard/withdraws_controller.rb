class Dashboard::WithdrawsController < Dashboard::BaseController
  def index
    @withdraws = current_user.withdraws.page params[:page]
  end
end
