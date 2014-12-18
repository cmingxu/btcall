class Dashboard::BidsController < Dashboard::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @bids = current_user.bids.page(params[:page])
  end

  def create
    @bid = current_user.bids.new(bid_params)
    @bid.open_at_code = open_at_code(@bid.open_at)

    respond_to do |format|
      if @bid.make_bid
        format.json  { render :json => {:result => true}}
      else
        format.json  { render :json => {:result => false}, :status => :unprocessable_entity }
      end
    end
  end

  def bid_params
    params[:bid].permit(:open_at, :amount, :trend)
  end
end
