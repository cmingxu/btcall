class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.datetime :open_at
      t.string :trend
      t.boolean :win
      t.integer :amount, :limit => 8
      t.integer :user_id
      t.string :status
      t.integer :order_price, :limit => 8
      t.integer :open_price, :limit => 8
      t.integer :win_reward, :limit => 8

      t.timestamps
    end
  end
end
