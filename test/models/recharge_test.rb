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
#  amount_decimal      :decimal(16, 8)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class RechargeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
