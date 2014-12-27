# == Schema Information
#
# Table name: maker_opens
#
#  id                   :integer          not null, primary key
#  open_at_code         :string(255)
#  user_id              :integer
#  platform_deduct_rate :integer
#  platform_deduct      :integer
#  net_income           :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class MakerOpen < ActiveRecord::Base
  belongs_to :user
end
