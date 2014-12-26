# -*- encoding : utf-8 -*-
class SendCoin
  @queue = :send_coin

  def self.perform(tid)
    BG_LOGGER.debug "entering send_coin #{tid}"
    return unless t = Transaction.find_by_id(tid)
    result, error_message, txid = BtcallAccount.send_to_bc_address(t.to_bc_address, t.bc_amount.to_f)
    if result
      BG_LOGGER.debug "send to #{t.to_bc_address} #{t.bc_amount} send_coin #{tid}"
      t.update_attribute :bc_sent_at, Time.now
      t.update_attribute :txid, txid
      t.send_coin!

    else
      BG_LOGGER.error error_message
    end
  end
end
