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
#

class Address < ActiveRecord::Base
  belongs_to :user
  has_many :recharges

  before_validation :on => :create do
    self.account_name = self.user.account_name
  end

  after_commit :gen_bitcoin_address, on: :create

  private
  def gen_bitcoin_address
    self.update_column :btcaddress, CoinRPC.new_bc_address_for_user(self.user)
  end
end
