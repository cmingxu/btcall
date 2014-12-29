class SmsNotice < ActiveRecord::Base
  belongs_to :user
  scope :latest_sms_notice, lambda { where(:status => "sent_out").order("id DESC").first }

  state_machine :status, :initial => :new_created do
    event :sent do
      transition :new_created => :sent_out
    end

    event :enter do
      transition :sent_out => :entered
    end
  end
end
