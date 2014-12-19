# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: withdraws
#
#  id            :integer          not null, primary key
#  amount        :decimal(10, 8)
#  to_bc_address :string(255)
#  txid          :string(255)
#  user_id       :integer
#  status        :string(255)
#  verified_at   :datetime
#  sent_at       :datetime
#  msg           :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Withdraw < ActiveRecord::Base

  belongs_to :user
  after_commit :job_to_send_coin

  state_machine :status, :initial => :new do
     event :send_coin do
       transition :new => :bc_sending
     end

     event :ack do
       transition :bc_sending => :bc_acked
     end
  end

  def job_to_send_coin
    Resque.enqueue_at Time.now, SendWithdrawCoin, self.user_id, self.id
    Resque.enqueue_at Time.now + 300, ConfirmWithdrawCoin, self.id
  end
end
