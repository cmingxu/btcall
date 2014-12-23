# == Schema Information
#
# Table name: makers
#
#  id             :integer          not null, primary key
#  decimal_amount :integer
#  amount         :integer
#  in_or_out      :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Maker < ActiveRecord::Base
  belongs_to :user
  validates :decimal_amount, presence: { message: "数量不能空" }
  validates :decimal_amount, numericality: { message: "数量不正确", :greater_than => 0.0001 }
  validate :user_have_sufficient_btc

  before_validation :set_defaults, :on => :create
  after_save :update_user_btc_balance_and_maker_btc_balance, :on => :create

  def user_have_sufficient_btc
    self.errors.add(:amount, "账户余额不足") if self.decimal_amount && self.decimal_amount > self.user.btc_balance
  end

  def set_defaults
    self.amount = float_to_int(self.decimal_amount)
  end

  def update_user_btc_balance_and_maker_btc_balance
    self.user.btc_balance -= self.decimal_amount
    self.user.maker_btc_balance += self.decimal_amount
    self.user.save
  end

  def in_or_out_in_word
    self.in_or_out == "in" ? "入市" : "出市"
  end
end
