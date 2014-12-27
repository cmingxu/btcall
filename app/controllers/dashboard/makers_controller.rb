class Dashboard::MakersController < Dashboard::BaseController
  def index
    @maker_records = current_user.makers.page params[:page]
    @maker_opens   = current_user.maker_opens.page params[:open_page]
  end

  def create
    @maker_record = current_user.makers.build maker_params
    if @maker_record.save
      redirect_to dashboard_makers_path, :alert => "操作成功"
    else
      redirect_to dashboard_makers_path, :notice => @maker_record.errors.full_messages.first
    end
  end

  def maker_params
    params[:maker][:amount] = btc_float_to_int(params[:maker][:amount])
    params[:maker].permit(:in_or_out, :amount)
  end
end
