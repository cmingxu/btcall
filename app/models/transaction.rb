# -*- encoding : utf-8 -*-
class Transaction < ActiveRecord::Base

  TTYPE = {
    "product_page" => "A",
    "direct_bc"    => "B",
    "direct_email" => "C",
    "out_site"     => "D"

  }
  attr_accessible :product_id, :status, :user_id, :bc_address_or_email, :msg, :rmb_amount
  belongs_to :product
  belongs_to :user

  validates :rmb_amount, :presence => true
  validates :rmb_amount, :numericality => {:less_than => Settings.max_allowed_value, :greater_than => 0}
  validate :bc_address_or_email_valid, :on => :create

  before_create do
    self.serial_num = TTYPE[self.ttype] + ("%010d" % (self.class.send(self.ttype).count + 1))
    self.rmb_amount = self.rmb_amount * 100
    self.rate       = Rate.fen_per_satoshi
    self.bc_amount  = Rate.rmb_to_bc(self.rmb_amount)
  end

  after_save :set_out_trade_no, :on => :create

  TTYPE.keys.each do  |t|
    scope t, -> { where "ttype='#{t}'" }
  end

  def bc_address_or_email_valid
    if self.bc_address_or_email.blank?
      self.ttype = "product_page"
      return true
    end

    if CoinRPC.validateaddress(self.bc_address_or_email)[:isvalid]
      # valid bc address within site
      if product = Product.find_by_bc_address(self.bc_address_or_email)
        self.product_id = product.id
        self.to_bc_address = self.bc_address_or_email
        self.ttype = "direct_bc"
        self.receiver_id = product.user_id
      else
        self.ttype = "out_site"
        # do noting currently , just send the fucking bitcoin
      end
    elsif self.bc_address_or_email =~ /\w+@\w+/
      if user = User.find_by_email(self.bc_address_or_email)
        self.ttype = "direct_email"
        self.product_id = user.default_product.id
        self.to_bc_address = user.bc_address
        self.receiver_id = user.id
      else
        self.errors.add(:bc_address_or_email, "email再本站不存在")
      end
    else
      self.errors.add(:bc_address_or_email, "比特币地址或者email不正确")
    end
  end


  state_machine :status, :initial => :unpaid do
    
    after_transition :on => :pay, :do => :do_coin_sending
    event :pay do
      transition :unpaid => :paid
    end

    event :send_coin do
      transition :paid => :bc_sending
    end

    event :ack do
      transition :bc_sending => :bc_acked
    end
  end

  def set_serial_num
    self.serial_num = TTYPE[self.ttype] + ("%010d" % (self.class.send(self.ttype).count + 1))
  end

  def set_rmb_amount
    self.rmb_amount = self.product.price
  end

  def set_out_trade_no
    if self.product
      update_column :out_trade_no, self.product.permanent_link[0..8] + ("%05d" % self.id) unless self.out_trade_no
    else
      update_column :out_trade_no, SecureRandom.hex(8) + ("%05d" % self.id) unless self.out_trade_no
    end
  end

  def status_in_word
    case self.status
    when "unpaid" then "未付款"
    when "paid" then "已付款"
    when "bc_sending" then "比特币发送中"
    when "bc_acked" then "比特币已送达"
    end
  end

  def do_coin_sending
    Resque.enqueue_at Time.now, SendCoin, self.id
    Resque.enqueue_at Time.now + 300, ConfirmCoin, self.id
  end

  def rmb_amount_to_yuan
    "%.2f" % (self.rmb_amount / 100)
  end
end
