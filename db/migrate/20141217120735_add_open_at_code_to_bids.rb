class AddOpenAtCodeToBids < ActiveRecord::Migration
  def change
    add_column :bids, :open_at_code, :string
  end
end
