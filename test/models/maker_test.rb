# == Schema Information
#
# Table name: makers
#
#  id         :integer          not null, primary key
#  amount     :integer
#  in_or_out  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class MakerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
