# == Schema Information
#
# Table name: bids
#
#  id           :integer          not null, primary key
#  open_at      :datetime
#  trend        :string(255)
#  win          :boolean
#  amount       :integer
#  user_id      :integer
#  status       :string(255)
#  order_price  :integer
#  open_price   :integer
#  win_reward   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  open_at_code :string(255)
#

require 'test_helper'

class BidTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
