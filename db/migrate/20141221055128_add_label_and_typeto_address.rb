class AddLabelAndTypetoAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :label, :string
    add_column :addresses, :type, :string
  end
end
