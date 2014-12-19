class AddWithdrawAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :withdraw_address, :string
  end
end
