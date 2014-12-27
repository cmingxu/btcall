class AddBtcBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btc_balance, :integer, :limit => 8
  end
end
