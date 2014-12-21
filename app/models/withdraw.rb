# -*- encoding : utf-8 -*- # == Schema Information # # Table name: withdraws # #  id                   :integer          not null, primary key #  amount               :decimal(10, 8) #  withdraw_address_id  :integer
#  withdraw_btc_address :string(255)
#  txid                 :string(255)
#  user_id              :integer
#  status               :string(255)
#  verified_at          :datetime
#  sent_at              :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Withdraw < ActiveRecord::Base
  include BcHelper

  belongs_to :withdraw_address
  belongs_to :user
  after_commit :job_to_send_coin

  validates :amount_decimal, presence: { message: "请输入提现数量" }
  validates :amount_decimal, numericality: { message: "金额不是合法金额", :greater_than => 0.0001 }
  validate :user_have_sufficient_btc

  before_validation :set_defaults, :on => :create

  state_machine :status, :initial => :new do

    after_transition :on => :bc_sending, :do => :deduct_user_btc_balance

     event :send_coin do
       transition :new => :bc_sending
     end

     event :ack do
       transition :bc_sending => :bc_acked
     end
  end

  def set_defaults
    self.amount = float_to_int(self.amount_decimal)
    self.withdraw_btc_address = self.withdraw_address.btcaddress
  end

  def job_to_send_coin
    Resque.enqueue_at Time.now, SendWithdrawCoin, self.user_id, self.id
    Resque.enqueue_at Time.now + 300, ConfirmWithdrawCoin, self.id
  end

  def user_have_sufficient_btc
    self.errors.add(:amount, "账户余额不足") if self.amount > self.user.btc_balance
  end

  def deduct_user_btc_balance
    self.user.adjust_btc_balance(-self.amount_decimal)
  end
end
