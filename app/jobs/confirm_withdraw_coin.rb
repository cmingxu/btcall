# -*- encoding : utf-8 -*-
class ConfirmWithdrawCoin
  @queue = :confirm_withdraw_coin

  def self.perform(wid)
    BG_LOGGER.debug "entering confirm_withdraw_coin #{wid}"
    return unless w = Withdraw.find_by_id(wid)


    begin
      res = CoinRPC.gettransaction w.txid
    rescue JSONRPCError => e
      BG_LOGGER.debug "JSONRPCError confirm withdraw coin faild = #{e.message}"
    rescue Exception => e
      BG_LOGGER.debug "Exception confirm withdraw coin faild = #{e.message}"
    end
    return unless res

    BG_LOGGER.debug "confirm success #{res}"

    if res[:confirmations] < 1
      BG_LOGGER.debug "retry confirm #{res[:confirmations]}"
      Resque.enqueue_at Time.now + 60, ConfirmWithdrawCoin, wid
    else
      BG_LOGGER.debug "confirm success"
      w.update_attribute :verified_at, Time.now
      w.ack!
    end
  end

end
