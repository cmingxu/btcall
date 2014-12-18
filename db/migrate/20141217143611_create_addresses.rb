class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :account_name
      t.integer :user_id
      t.string :btcaddress

      t.timestamps
    end
  end
end
