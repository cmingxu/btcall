# -*- encoding : utf-8 -*-
module BcHelper
  def send_to_bc_address(bc_address, amount)
    begin
      txid = CoinRPC.sendfrom BtcallAccount.account_name, bc_address, amount
      BG_LOGGER.debug "send_to_bc_address #{BtcallAccount.account_name} #{bc_address} #{amount}"
    rescue JSONRPCError => e
      feedback = eval(e.message)
      BG_LOGGER.debug "send_to_bc_address faild = #{e.message}"
      return [false, BITCOIND_ERROR_MAP[feedback["code"]] || feedback["message"]]
    rescue Exception => e
      return [false, e.message, nil]
    end

    BG_LOGGER.debug "success"

    return [true, nil, txid]
  end
end
