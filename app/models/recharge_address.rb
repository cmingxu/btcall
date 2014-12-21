class RechargeAddress < Address
  has_many :recharges


  after_commit :gen_bitcoin_address, on: :create

  private
  def gen_bitcoin_address
    self.update_column :btcaddress, CoinRPC.new_bc_address_for_user(self.user)
  end
end
