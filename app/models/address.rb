class Address < ActiveRecord::Base
  belongs_to :user

  before_validation :on => :create do
    self.account_name = self.user.account_name
  end

  after_commit :gen_bitcoin_address, on: :create

  private
  def gen_bitcoin_address
    self.update_column :btcaddress, CoinRPC.new_bc_address_for_user(self.user)
  end
end
