# -*- encoding : utf-8 -*-
class WubalaAccount
  class << self
    attr_accessor :account_name
    include BcHelper

    # 账号余额
    def getbalance
      CoinRPC.getbalance self.account_name
    end

    def send_bc_to_address(bc_amount, address)
    end

    # 向其他账号发送bitcoin
    def transaction_to(bc_address, bc_amount)
    end

    # 返回account对应的地址
    def bc_address
      CoinRPC.getaddressesbyaccount @account_name
    end

    # 新建account, 只调用一次
    def new_account
      CoinRPC.getaccountaddress @account_name
    end
  end

  self.account_name = "wubala"

end
