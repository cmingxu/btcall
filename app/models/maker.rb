# == Schema Information
#
# Table name: makers
#
#  id             :integer          not null, primary key
#  decimal_amount :integer
#  amount         :integer
#  in_or_out      :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Maker < ActiveRecord::Base
end
