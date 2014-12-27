class CreatePlatformOpens < ActiveRecord::Migration
  def change
    create_table :platform_opens do |t|
      t.string :open_at_code
      t.integer :user_id
      t.integer :int_amount, :limit => 8

      t.timestamps
    end
  end
end
