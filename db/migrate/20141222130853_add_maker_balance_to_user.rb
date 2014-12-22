class AddMakerBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :maker_btc_balance, :decimal, :precision => 10, :scale => 4
  end
end
