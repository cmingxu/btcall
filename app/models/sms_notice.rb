class SmsNotice < ActiveRecord::Base
  validates :phone, presence: { :message => "手机号码不能空" }
  validates :param, presence: { message: "参数不能空" }

  belongs_to :user

  state_machine :status, :initial => :new_created do
    event :sent do
      transition :new_created => :sent_out
    end

    event :enter do
      transition :sent_out => :entered
    end
  end
end
