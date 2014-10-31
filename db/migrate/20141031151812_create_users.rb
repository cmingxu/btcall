class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.string :last_login_ip
      t.datetime :last_login_at
      t.string :reset_password_token
      t.string :status

      t.timestamps
    end
  end
end
