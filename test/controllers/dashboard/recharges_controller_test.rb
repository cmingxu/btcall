require 'test_helper'

class Dashboard::RechargesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
