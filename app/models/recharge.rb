class Recharge < ActiveRecord::Base
  belongs_to :user
  belongs_to :address

  state_machine :status, :initial => :unconfirmed do
    after_transition :on => :confirmed, :do => :add_to_user_btc_balance

    event :confirm do
      transition :unconfirmed => :confirmed
    end
  end

  def add_to_user_btc_balance
    self.user.adjust_btc_balance self.amount
  end

  def self.scan_transactions_in_block_chain
    transactions = CoinRPC.listtransactions '*', Settings.listtransactions_count
    transactions.each do |t|
      next if t['category'] != 'receive'
      next if User.find_by_account(t['account']).nil?
      recharge = Recharge.find_by_txid(t['txid'])
      if recharge.nil?
        Recharge.create do |r|
          r.account = t['account']
          r.btc_address = t['address']
          r.txid = t['txid']
          r.user_id = User.find_by_account(t['account']).try(:id)
          r.address_id = Address.find_by_btcaddress(t['address']).try(:id)
          r.amount = float_to_int(t['amount'])
          r.amount_decimal = t['amount']
        end

      elsif recharge && recharge.unconfirmed? && t['confirmations'] >= 1
        recharge.confirm!
      end
    end
  end
end
