# -*- encoding : utf-8 -*-
class Withdraw < ActiveRecord::Base

  belongs_to :user
  validates :to_bc_address, :presence => { :message => "必填内容"}
  validates :amount, :presence => { :message => "必填内容"}
  validates :amount, :numericality => {:greater_than => 0, :message => "必须为数字"}
  validate :bc_address_valid, :on => :create
  validate :account_has_sufficient_bc, :on => :create
  after_commit :job_to_send_coin

  state_machine :status, :initial => :new do
     event :send_coin do
       transition :new => :bc_sending
     end

     event :ack do
       transition :bc_sending => :bc_acked
     end
  end

  def bc_address_valid
    self.errors.add(:to_bc_address, "比特币地址不正确") unless CoinRPC.validateaddress(self.to_bc_address)[:isvalid]
  end

  def account_has_sufficient_bc
    self.errors.add(:amount, "比特币余额不足") if self.amount && self.user.get_balance < self.amount
  end

  def job_to_send_coin
    Resque.enqueue_at Time.now, SendWithdrawCoin, self.user_id, self.id
    Resque.enqueue_at Time.now + 300, ConfirmWithdrawCoin, self.id
  end
end
