# -*- encoding : utf-8 -*-
class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.decimal :amount, :precision => 10, :scale => 8
      t.string  :withdraw_address
      t.string :txid
      t.integer :user_id
      t.string :status
      t.datetime :verified_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
