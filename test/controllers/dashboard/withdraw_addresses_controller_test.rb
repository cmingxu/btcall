require 'test_helper'

class Dashboard::WithdrawAddressesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
