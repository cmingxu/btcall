class CreateRecharges < ActiveRecord::Migration
  def change
    create_table :recharges do |t|
      t.string :txid
      t.string :status
      t.string :btc_address
      t.integer :address_id
      t.integer :user_id
      t.integer :amount
      t.string :account
      t.decimal :amount_decimal, :precision => 10, :scale => 8

      t.timestamps
    end
  end
end
