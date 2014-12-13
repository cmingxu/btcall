# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  login                :string(255)
#  email                :string(255)
#  encrypted_password   :string(255)
#  salt                 :string(255)
#  last_login_ip        :string(255)
#  last_login_at        :datetime
#  reset_password_token :string(255)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  activation_code      :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
