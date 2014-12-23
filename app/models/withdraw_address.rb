# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  account_name :string(255)
#  user_id      :integer
#  btcaddress   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  label        :string(255)
#  type         :string(255)
#

class WithdrawAddress < Address
  has_many :withdraws
  validates :label,  :presence => { :message => "输入一个标签" }
  validates :label, uniqueness: { message: "标签重复出现了多次" }
  validates :btcaddress, presence: { message: "地址不能空" }
  validates :btcaddress, uniqueness: { message: "提现地址重复了", :scope => :user_id }

  def address_with_label
    "@#{self.label} - #{self.btcaddress}"
  end
end
