class CreateSmsNotices < ActiveRecord::Migration
  def change
    create_table :sms_notices do |t|
      t.string :template_id
      t.string :template_content
      t.string :param
      t.string :phone
      t.string :status
      t.string :send_reason
      t.integer :user_id
      t.datetime :entered_at

      t.timestamps
    end
  end
end
