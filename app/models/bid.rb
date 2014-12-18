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

  scope :win, lambda { where(win: true) }
  scope :lose, lambda { where(win: false) }

  def set_defaults
    self.win = false
    #self.new_created!
    self.order_price = current_btc_price_in_int
  end

  def make_bid
    self.user.btc_balance = self.user.btc_balance - self.amount
    begin
      self.class.transaction do
        self.user.save!
        save
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def finish_bid(open_price)
    if open_price > self.order_price && self.trend == "up"
      self.win = true
      self.win_reward = self.amount * (Settings.odds - 1).floor
    else
      self.win = false
      self.win_reward = - self.amount
    end
    self.open_price = open_price

    begin
      self.class.transaction do
        self.user.adjust_btc_balance(self.win_reward)
        save!
        true
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
