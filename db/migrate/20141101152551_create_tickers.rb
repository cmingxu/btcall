class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.string :soure
      t.integer :high
      t.integer :low
      t.integer :buy
      t.integer :sell
      t.integer :last
      t.integer :vol

      t.timestamps
    end
  end
end
