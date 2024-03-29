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

  #enum status: [:new_created, :open]

  scope :win, lambda { where(win: true) }
  scope :lose, lambda { where(win: false) }

  [:new_created, :open].each do |s|
    scope s, -> { where(status: s) }
  end

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

        buy_win_rate = (Bid.where("open_at_code = #{self.open_at_code} AND trend = 'up'").count / Bid.where("open_at_code = #{self.open_at_code}").count.to_f)
        WinRate.set_win_rates self.open_at_code, buy_win_rate
        SiteActivity.puts_stream_open(self)
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def status_in_word
    case self.status
    when "new_created"
      "未开"
    when "open"
      "已开"
    end
  end

  def self.finish_bid(bid_code = open_at_code(Time.now))
    BG_LOGGER.debug "oooooooooooooooooooo BEGIN #{bid_code} oooooooooooooooooooooo"
    current_btc_price = current_btc_price_in_int
    begin
      ActiveRecord::Base.transaction do
        total_btc = 0
        bids_in_batch = Bid.where(open_at_code: bid_code, status: "new_created")
        return if bids_in_batch.count.zero?
        bids_in_batch.all.each do |bid|
          BG_LOGGER.debug "oooooooooooooooooooo checking bid #{bid.id} oooooooooooooooooooooo"
          if current_btc_price > bid.order_price && bid.trend == "up"
            bid.win = true
            bid.win_reward = (bid.amount * (Settings.odds - 1)).floor
          elsif current_btc_price < bid.order_price && bid.trend == "down"
            bid.win = true
            bid.win_reward = (bid.amount * (Settings.odds - 1)).floor
          else
            bid.win = false
            bid.win_reward = -bid.amount
          end

          total_btc += bid.win_reward

          bid.open_price = current_btc_price
          bid.status = "open"
          bid.save!
          bid.user.adjust_btc_balance(bid.win_reward)
          BG_LOGGER.debug "oooooooooooooooooooo  bid win #{bid.id}  #{bid.win_reward} oooooooooooooooooooooo"
        end


        # for maker side - flip value
        total_btc = -total_btc
        return if total_btc.zero?

        User.makers.each do |maker|
          #TDOO add lower limit for maker to participate the market
          BG_LOGGER.debug "oooooooooooooooooooo maker cal #{maker.id} oooooooooooooooooooooo"
          maker_share = maker.my_maker_share * total_btc
          platform_deduct = total_btc > 0 ? maker_share * Settings.platform_interest : 0
          maker_net_income = total_btc > 0 ? maker_share * (1 - Settings.platform_interest) : maker_share

          maker.maker_btc_balance += maker_net_income
          BG_LOGGER.debug "oooooooooooooooo create maker_open   #{maker.id} #{platform_deduct} #{maker_net_income} oooooooooooooooooooooo"
          maker.maker_opens.create!(:open_at_code => bid_code,
                                    :platform_deduct_rate => Settings.platform_interest * 100,
                                    :platform_deduct => platform_deduct,
                                    :net_income => maker_net_income
                                   )
          SiteActivity.puts_stream_win(maker.maker_opens.last) if maker_net_income > 0

          if total_btc > 0
            BG_LOGGER.debug "oooooooooooooooo create platform open   #{maker.id} #{platform_deduct} oooooooooooooooooooooo"
            maker.platform_opens.create!(:open_at_code => bid_code,
                                         :amount => platform_deduct)
          end
          maker.save!
        end

      end
      BG_LOGGER.debug "oooooooooooooooooooo DONE #{bid_code} oooooooooooooooooooooo"
    rescue ActiveRecord::RecordInvalid
      BG_LOGGER.error "xxxxxxxxxxxxxxxxxxxx ROLLBACK #{bid_code} xxxxxxxxxxxxxxxxxxxxx"
    end
  end
end
