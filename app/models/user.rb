# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  login                :string(255)
#  email                :string(255)
#  encrypted_password   :string(255)
#  salt                 :string(255)
#  last_login_ip        :string(255)
#  last_login_at        :datetime
#  reset_password_token :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  activation_code      :string(255)
#  account              :string(255)
#  btc_balance          :decimal(10, 4)
#  withdraw_address     :string(255)
#

require 'digest/md5'

class User < ActiveRecord::Base
  STATUS = %w(new_join activated suspended)
  attr_accessor :password, :password_confirmation, :captcha

  validates :email, presence: { :message => "Email不能为空" }
  validates :email, uniqueness: { :message => "Email已经存在， 尝试我们的找回密码功能" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "Email格式不正确" }
  validate :sufficient_btc_balance, :on => :update

  after_create :set_initial_status

  has_many :bids, :dependent => :destroy
  has_one :recharge_address
  has_many :withdraw_addresses
  has_many :recharges
  has_many :withdraws

  User::STATUS.each do |status|
    scope status, -> { where(status: status) }
  end

  def password=(new_password)
    self.salt = SecureRandom.hex(16)
    self.encrypted_password = Digest::MD5.hexdigest([self.salt, new_password].join(":"))
  end


  def self.login(params)
    if user = self.activated.find_by_email(params[:email])
      return nil unless user.password_valid?(params[:password])
    end
    user
  end

  def password_valid?(pass)
    self.encrypted_password == Digest::MD5.hexdigest([self.salt, pass].join(":"))
  end

  def active!
    return true if self.activated?
    self.update_column :activation_code, ""
    self.update_column :status, "activated"
    self.update_column :account, self.account_name
    RechargeAddress.new do |a|
      a.label = "default"
      a.user = self
    end.save
  end

  def account_name
    self.account || "user-#{self.id}-#{SecureRandom.hex(16)}"
  end

  def admin?
  end

  def activated?
    self.status == "activated"
  end

  def win_rate
    self.bids.count.zero? ? 0 : (self.bids.win.count / self.bids.count.to_f)
  end

  def btc_balance_enough?(amount)
    self.btc_balance > amount
  end

  def sufficient_btc_balance
    self.errors.add :btc_balance, "账户内比特币余额不足" if self.btc_balance < 0
  end

  def adjust_btc_balance(amount)
    self.btc_balance += amount
    self.save
  end

  private
  def set_initial_status
    self.update_column :status, User::STATUS.first
    self.update_column :reset_password_token, SecureRandom.hex(16)
    self.update_column :activation_code, SecureRandom.hex(32)
    self.update_column :btc_balance, 0
  end
end
