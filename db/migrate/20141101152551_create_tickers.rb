class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.string :soure
      t.int :high
      t.int :low
      t.int :buy
      t.int :sell
      t.int :last
      t.int :vol

      t.timestamps
    end
  end
end
