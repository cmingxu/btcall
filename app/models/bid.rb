# == Schema Information
#
# Table name: bids
#
#  id          :integer          not null, primary key
#  open_at     :datetime
#  trend       :string(255)
#  win         :boolean
#  amount      :integer
#  user_id     :integer
#  status      :string(255)
#  order_price :integer
#  open_price  :integer
#  win_reward  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Bid < ActiveRecord::Base
  belongs_to :user
  before_validation :set_defaults, :on => :create

  enum status: [:new_created, :open]

  def set_defaults
    self.win = false
    #self.new_created!
    self.order_price = current_btc_price_in_int
  end


end
