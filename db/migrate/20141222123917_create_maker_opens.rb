class CreateMakerOpens < ActiveRecord::Migration
  def change
    create_table :maker_opens do |t|
      t.string :open_at_code
      t.integer :user_id
      t.integer :platform_deduct_rate
      t.integer :platform_deduct, :limit => 8
      t.integer :net_income, :limit => 8

      t.timestamps
    end
  end
end
