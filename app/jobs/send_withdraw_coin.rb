# -*- encoding : utf-8 -*-
class SendWithdrawCoin
  @queue = :send_withdraw_coin

  def self.perform(user_id, wid)
    BG_LOGGER.debug "entering send_withdraw_coin #{wid}"
    w = Withdraw.find(wid)
    u = User.find(user_id)
    raise Exception.new("#{u.email}账号余额不足") if u.btc_balance < w.amount

    result, error_message, txid = w.send_to_bc_address(w.withdraw_btc_address, btc_int_to_float(w.amount))
    BG_LOGGER.debug "#{result} #{error_message} #{txid}"
    BG_LOGGER.debug "#{result}"
    if result
      BG_LOGGER.debug "send to #{w.withdraw_btc_address} #{btc_int_to_float(w.amount)} send_withdraw_coin #{wid}"
      w.update_attribute :sent_at, Time.now
      w.update_attribute :txid, txid
      w.send_coin!

    else
      BG_LOGGER.error error_message
    end
  end
end
