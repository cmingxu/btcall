# == Schema Information
#
# Table name: maker_opens
#
#  id                   :integer          not null, primary key
#  open_at_code         :string(255)
#  user_id              :integer
#  platform_deduct_rate :integer
#  platform_deduct      :integer
#  net_income           :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class MakerOpenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
