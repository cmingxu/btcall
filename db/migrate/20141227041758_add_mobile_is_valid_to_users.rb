class AddMobileIsValidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_is_valid, :boolean
  end
end
