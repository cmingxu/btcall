# == Schema Information
#
# Table name: recharges
#
#  id                  :integer          not null, primary key
#  txid                :string(255)
#  status              :string(255)
#  btc_address         :string(255)
#  recharge_address_id :integer
#  user_id             :integer
#  amount              :integer
#  account             :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Recharge < ActiveRecord::Base
  belongs_to :user
  belongs_to :recharge_address

  state_machine :status, :initial => :unconfirmed do
    after_transition :on => :confirm, :do => :add_to_user_btc_balance
    after_transition :on => :confirm, :do => :move_to_btcall_account

    event :confirm do
      transition :unconfirmed => :confirmed
    end
  end

  def add_to_user_btc_balance
    self.user.adjust_btc_balance self.amount
  end

  def move_to_btcall_account
    Resque.enqueue_at Time.now, MoveToBtcall, self.user.account_name, btc_int_to_float(self.amount)
  end

  def status_in_word
    case self.status
    when "unconfirmed"
      "收到/确认中"
    when "confirmed"
      "收到/已确认"
    end
  end

  def self.scan_transactions_in_block_chain
    BG_LOGGER.debug "checking new transactions .... "
    transactions = CoinRPC.listtransactions '*', Settings.listtransactions_count
    transactions.each do |t|
      next if t['category'] != 'receive'
      next if User.find_by_account(t['account']).nil?
      recharge = Recharge.find_by_txid(t['txid'])
      if recharge.nil?
        BG_LOGGER.debug "creating transaction  #{t['txid']}"
        Recharge.create! do |r|
          r.account = t['account']
          r.btc_address = t['address']
          r.txid = t['txid']
          r.user_id = User.find_by_account(t['account']).try(:id)
          r.recharge_address_id = RechargeAddress.find_by_btcaddress(t['address']).try(:id)
          r.amount = btc_float_to_int(t['amount'])
        end

      elsif recharge && recharge.unconfirmed? && t['confirmations'] >= 1
        BG_LOGGER.debug "confirming transaction  #{t['txid']}"
        recharge.confirm!
      end
    end
  end
end
