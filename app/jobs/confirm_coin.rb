# -*- encoding : utf-8 -*-
class ConfirmCoin
  @queue = :confirm_coin

  def self.perform(tid)
    BG_LOGGER.debug "entering confirm_coin #{tid}"
    return unless t = Transaction.find_by_id(tid)


    begin
      res = CoinRPC.gettransaction t.txid
    rescue JSONRPCError => e
      BG_LOGGER.debug "JSONRPCError coirm coin faild = #{e.message}"
    rescue Exception => e
      BG_LOGGER.debug "Exception coirm coin faild = #{e.message}"
    end
    BG_LOGGER.debug "confirm success #{res}"
    return unless res

    if res[:confirmations] < 6
      BG_LOGGER.debug "retry confirm #{res[:confirmations]}"
      Resque.enqueue_at Time.now + 60, ConfirmCoin, tid
    else
      BG_LOGGER.debug "confirm success"
      t.update_attribute :verified_at, Time.now
      t.ack!
    end
  end

end
