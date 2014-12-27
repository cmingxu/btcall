class CreateRecharges < ActiveRecord::Migration
  def change
    create_table :recharges do |t|
      t.string :txid
      t.string :status
      t.string :btc_address
      t.integer :recharge_address_id
      t.integer :user_id
      t.integer :amount, :limit => 8
      t.string :account

      t.timestamps
    end
  end
end
