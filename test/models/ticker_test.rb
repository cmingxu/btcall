# == Schema Information
#
# Table name: tickers
#
#  id         :integer          not null, primary key
#  soure      :string(255)
#  high       :integer
#  low        :integer
#  buy        :integer
#  sell       :integer
#  last       :integer
#  vol        :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class TickerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
