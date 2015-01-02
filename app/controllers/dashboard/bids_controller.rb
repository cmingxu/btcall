class Dashboard::BidsController < Dashboard::BaseController
  skip_before_action :verify_authenticity_token

  def index
    respond_to do |format|
      format.html do
        @bids = current_user.bids.page(params[:page])
      end

      format.js do
        if params[:status] == "new_created"
          @bids = current_user.bids.new_created.limit(10)
          render partial: 'created_list', :locals => { :bids => @bids }
        else
          @bids = current_user.bids.open.limit(10)
          render partial: 'open_list', :locals => { :bids => @bids }
        end
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
