class CreateMakerOpens < ActiveRecord::Migration
  def change
    create_table :maker_opens do |t|
      t.string :open_at_code
      t.integer :user_id
      t.integer :platform_deduct_rate
      t.integer :platform_deduct
      t.decimal :platform_deduct_decimal, :precision => 10, :scale => 4
      t.integer :net_income
      t.integer :net_income_decimal, :precision => 10, :scale => 4

      t.timestamps
    end
  end
end
