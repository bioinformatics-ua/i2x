require 'test_helper'

class PostmanControllerTest < ActionController::TestCase
  test "should get deliver" do
    get :deliver
    assert_response :success
  end

end
