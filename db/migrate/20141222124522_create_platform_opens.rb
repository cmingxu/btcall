class CreatePlatformOpens < ActiveRecord::Migration
  def change
    create_table :platform_opens do |t|
      t.string :open_at_code
      t.integer :user_id
      t.integer :int_amount
      t.decimal :decimal_amount, :precision => 10, :scale => 4

      t.timestamps
    end
  end
end
