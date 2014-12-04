# -*- encoding : utf-8 -*-
require 'digest'
class User < ActiveRecord::Base
  include BcHelper
  attr_accessible :email, :password
  attr_accessor :password

  mount_uploader :avatar, AvatarUploader # 头像上传

  serialize :role, Array

  has_many :products, :conditions => "is_default = 0"
  has_many :transactions, :finder_sql => proc {  "select * from transactions where user_id = #{self.id} OR receiver_id= #{self.id}" }
  has_many :sent_transactions, :foreign_key => :user_id, :class_name => "Transaction"
  has_many :received_transactions, :foreign_key => :receiver_id, :class_name => "Transaction"
  has_one :default_product, :class_name => "Product", :conditions => {:is_default => true}
  has_many :withdraws

  validate :password_valid
  validates :email, :format => { :with => EMAIL_EXP, :message => "Email 格式不正确" }
  validates :email, :presence => {:message => "Email 不存在"}
  validates :email, :uniqueness => {:message => "EMAIL已经存在"}

  after_create :renew_login_token
  after_create :create_default_product_for_user#, :if => :new_record? # 3.2以上:on无效了
  before_save :secure_password, :on => :create# # 3.2以上:on无效了

  def password_valid
    self.errors.add(:password, "密码不能空") if self.password.blank?
    self.errors.add(:password, "密码长度最小为六位") if self.password && self.password.length < 6
  end

  def secure_password
    self.salt = SecureRandom.hex(10)
    self.encrypted_password = encryption_password(self.password)
  end

  def self.authenticate(u, p)
    user = User.find_by_login(u)
    user.password_valid?(p) ? user : nil
  end


  def password_valid?(password)
    encryption_password(password) == self.encrypted_password
  end

  def encryption_password(password)
    Digest::MD5.hexdigest self.salt + "shutaidong" + password
  end

  def get_balance
    CoinRPC.getbalance self.account_name
  end

  def get_bc_addresses
    CoinRPC.getaddressesbyaccount self.account_name
  end

  # 是否是管理员
  def admin?
    Settings.admin_emails.include?(self.email)
  end

  def renew_login_token
    self.update_attribute(:login_token,  SecureRandom.hex(10))
  end

  def create_default_product_for_user
    p = Product.new  do |p|
      p.name = "默认"
      p.description =  "default"
      p.is_default = true
      p.active = true
      p.user_id = self.id
      p.price = 0
    end
    p.save
    self.update_column :bc_address , p.bc_address
  end

  def account_name
    "user_#{self.id}" 
  end
end



