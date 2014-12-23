# -*- encoding : utf-8 -*-
class OpenBid
  @queue = :open_bid

  def self.perform(bid_code)
    BG_LOGGER.debug "=" * 30 + bid_code + "=" * 30
    Bid.finish_bid(bid_code)
  end
end
