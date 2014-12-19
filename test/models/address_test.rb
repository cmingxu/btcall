# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  account_name :string(255)
#  user_id      :integer
#  btcaddress   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
