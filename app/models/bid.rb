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

class Bid < ActiveRecord::Base
  belongs_to :user
  before_validation :set_defaults, :on => :create


  validates :amount, presence: { message: "请输入提现数量" }
  validates :amount, numericality: { message: "金额不是合法金额", :greater_than =>0.0001 * (10 ** 8) }
  validate :user_have_sufficient_btc

  enum status: [:new_created, :open]

  scope :win, lambda { where(win: true) }
  scope :lose, lambda { where(win: false) }

  def set_defaults
    self.win = false
    self.status = "new_created"
    self.order_price = current_btc_price_in_int
  end


  def user_have_sufficient_btc
    self.errors.add(:amount, "账户余额不足") if self.user.btc_balance < 0
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

  def self.finish_bid(bid_code)
    current_btc_price = current_btc_price_in_int
    begin
      ActiveRecord::Base.transaction do
        total_btc = 0
        Bid.where(open_at_code: bid_code).all.each do |bid|
          if current_btc_price > bid.order_price && bid.trend == "up"
            bid.win = true
            bid.win_reward = bid.amount * (Settings.odds - 1).floor
          else
            bid.win = false
            bid.win_reward = - bid.amount
          end

          total_btc += bid.win_reward

          bid.open_price = current_btc_price
          bid.status = "open"
          bid.save
          bid.user.adjust_btc_balance(bid.win_reward)
        end

        User.makers.each do |maker|
          #TDOO add lower limit for maker to participate the market
          maker_share = maker.my_maker_share * total_btc
          platform_deduct = maker_share * Settings.platform_interest
          maker_net_income = maker_share * (1 - Settings.platform_interest)
          maker.maker_btc_balance += maker_net_income
          maker.maker_opens.create!(:open_at_code => bid_code,
                                    :platform_deduct_rate => Settings.platform_interest * 100,
                                    :platform_deduct => platform_deduct,
                                    :platform_deduct_decimal => btc_int_to_float(platform_deduct),
                                    :net_income => net_income,
                                    :net_income_decimal => btc_int_to_float(net_income)
                                   )

          maker.platform_opens.create!(:open_at_code => bid_code,
                                        :int_amount => net_income)
          maker.save
        end

      end
      BG_LOGGER.error "oooooooooooooooooooo DONE #{bid_code} oooooooooooooooooooooo"
    rescue ActiveRecord::RecordInvalid
      BG_LOGGER.error "xxxxxxxxxxxxxxxxxxxx ROLLBACK #{bid_code} xxxxxxxxxxxxxxxxxxxxx"
    end
  end
end
