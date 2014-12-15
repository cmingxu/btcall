class Dashboard::BidsController < Dashboard::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @bids = current_user.bids.page(params[:page])
  end

  def create
    @bid = current_user.bids.new(bid_params)

    respond_to do |format|
      if @bid.save
        format.json  { render :json => {:result => true}}
      else
        format.json  { render :json => {:result => false}}
      end
    end
  end

  def bid_params
    params[:bid].permit(:open_at, :amount, :trend)
  end
end
