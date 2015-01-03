class Dashboard::BidsController < Dashboard::BaseController
  skip_before_action :verify_authenticity_token

  def index
    begin_at = params[:begin_at].presence || "2001-1-1"
    end_at = params[:end_at].presence || "2101-1-1"

    respond_to do |format|
      format.html do
        @bids = current_user.bids.where(["created_at > ? AND created_at < ?", begin_at, end_at]).page(params[:page])
      end

      format.json do
        @right_side_notice_open = SiteActivity.gets_from_stream_open
        @right_side_notice_win = SiteActivity.gets_from_stream_win
        @buy_win_rate               = WinRate.get_buy_win_rates

        if params[:status] == "new_created"
          @bids = current_user.bids.new_created.limit(10)
          partial = "dashboard/bids/created_list"
        else
          @bids = current_user.bids.open.limit(10)
          partial = "dashboard/bids/open_list"
        end

        render :json => {
          :content => render_to_string(:partial => partial, :locals => {:bids => @bids}, :formats => :html),
          :buy_win_rate => @buy_win_rate,
          :right_side_notice_win => @right_side_notice_win,
          :right_side_notice_open => @right_side_notice_open
        }
      end
    end
  end

  def create
    @bid = current_user.bids.new(bid_params)
    @bid.open_at_code = open_at_code(@bid.open_at)

    respond_to do |format|
      if @bid.make_bid
        format.json  { render :json => {:result => true, :msg => "success"}}
      else
        format.json  { render :json => {:result => false, :msg => @bid.errors.full_messages.first}, :status => :unprocessable_entity }
      end
    end
  end

  def bid_params
    params[:bid][:amount] = btc_float_to_int(params[:bid][:amount])
    params[:bid].permit(:open_at, :amount, :trend)
  end
end
