require 'test_helper'

class DeliveryControllerTest < ActionController::TestCase
  test "should get go" do
    get :go
    assert_response :success
  end

  test "should get get" do
    get :get
    assert_response :success
  end

end
