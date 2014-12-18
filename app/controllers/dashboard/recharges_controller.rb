class Dashboard::RechargesController < Dashboard::BaseController
  def index
    @recharges = current_user.recharges.page params[:page]
  end
end
