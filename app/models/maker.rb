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

class Maker < ActiveRecord::Base
  belongs_to :user
  validates :amount, presence: { message: "数量不能空" }
  validates :amount, numericality: { message: "数量不正确", :greater_than => 0.0001 * (10 ** 8)}
  validate :user_have_sufficient_btc

  before_validation :set_defaults, :on => :create
  after_save :update_user_btc_balance_and_maker_btc_balance, :on => :create

  def user_have_sufficient_btc
    self.errors.add(:amount, "账户余额不足") if self.amount && self.amount > self.user.btc_balance
  end

  def set_defaults
  end

  def update_user_btc_balance_and_maker_btc_balance
    amount = self.in_or_out == "out" ?  -self.amount  : self.amount

    self.user.btc_balance -= amount
    self.user.maker_btc_balance += amount
    self.user.save
  end

  def in_or_out_in_word
    self.in_or_out == "in" ? "入市" : "出市"
  end
end
