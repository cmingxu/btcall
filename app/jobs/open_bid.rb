# -*- encoding : utf-8 -*-
class OpenBid
  @queue = :open_bid

  def self.perform(bid_code)
    BG_LOGGER.debug "entering open_bid #{bid_code}"
    btc_price = current_btc_price_in_int
    Bid.where(open_at_code: bid_code).each do |bid|
      if bid.finish_bid(btc_price)
        BG_LOGGER.debug "finished bid #{bid.id}"
      else
        BG_LOGGER.error "error with bid  #{bid.id}"
      end
    end
  end
end
