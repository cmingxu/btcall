# -*- encoding : utf-8 -*-
class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :amount, :limit => 8
      t.integer :withdraw_address_id
      t.string :withdraw_btc_address
      t.string :txid
      t.integer :user_id
      t.string :status
      t.datetime :verified_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
