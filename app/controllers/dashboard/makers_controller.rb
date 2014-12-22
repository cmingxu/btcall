class Dashboard::MakersController < Dashboard::BaseController
  def index
    @maker_records = current_user.makers.page params[:page]
    @maker_opens   = current_user.maker_opens.page params[:open_page]
  end

  def create
  end
end
