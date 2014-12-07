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
#

require 'digest/md5'

class User < ActiveRecord::Base
  STATUS = %w(new_join activated suspended)
  attr_accessor :password, :password_confirmation, :captcha

  validates :email, presence: { :message => "Email不能为空" }
  validates :email, uniqueness: { :message => "Email已经存在， 尝试我们的找回密码功能" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "Email格式不正确" }

  after_create :set_initial_status

  User::STATUS.each do |status|
    scope status, -> { where(status: status) }
  end

  def password=(new_password)
    self.salt = SecureRandom.hex(16)
    self.encrypted_password = Digest::MD5.hexdigest([self.salt, new_password].join(":"))
  end


  def self.login(params)
    if user = (self.activated.find_by_email(params[:email]) || self.activated.find_by_name(params[:name]))
      return nil unless user.password_valid?(params[:password])
    end
    user
  end

  def password_valid?(pass)
    self.encrypted_password == Digest::MD5.hexdigest([self.salt, pass].join(":"))
  end

  private
  def set_initial_status
    self.update_column :status, User::STATUS.first
    self.update_column :reset_password_token, SecureRandom.hex(16)
  end
end
