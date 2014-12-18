class AddBtcBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btc_balance, :decimal, :precision => 10, :scale => 4
  end
end
