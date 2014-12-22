# == Schema Information
#
# Table name: platform_opens
#
#  id           :integer          not null, primary key
#  open_at_code :string(255)
#  user_id      :integer
#  int_amount   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class PlatformOpenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
