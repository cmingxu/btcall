class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.datetime :open_at
      t.string :trend
      t.boolean :win
      t.integer :amount
      t.integer :user_id
      t.string :status
      t.integer :order_price
      t.integer :open_price
      t.integer :win_reward

      t.timestamps
    end
  end
end
