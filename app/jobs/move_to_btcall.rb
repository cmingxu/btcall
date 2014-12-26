# -*- encoding : utf-8 -*-
class MoveToBtcall
  @queue = :move_to_btcall

  def self.perform(from_account, amount)
    BG_LOGGER.debug "entering move_to_btcall #{from_account}, #{amount}"

    begin
      res = CoinRPC.move from_account, BtcallAccount.account_name, amount.to_f
    rescue JSONRPCError => e
      BG_LOGGER.debug "JSONRPCError move to btcall faild = #{e.message}"
    rescue Exception => e
      BG_LOGGER.debug "Exception move to btcall faild = #{e.message}"
    end
    return unless res

    BG_LOGGER.debug "move success #{res}"

  end

end
