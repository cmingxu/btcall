class CreateMakers < ActiveRecord::Migration
  def change
    create_table :makers do |t|
      t.decimal :decimal_amount
      t.integer :amount
      t.string :in_or_out
      t.integer :user_id

      t.timestamps
    end
  end
end
