require 'test_helper'

class ArchitectureControllerTest < ActionController::TestCase
  test "should get models" do
    get :models
    assert_response :success
  end

  test "should get components" do
    get :components
    assert_response :success
  end

  test "should get flows" do
    get :flows
    assert_response :success
  end

end
