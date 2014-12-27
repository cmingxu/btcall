class AddMakerBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :maker_btc_balance, :integer, :limit => 8
  end
end
