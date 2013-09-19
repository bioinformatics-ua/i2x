require 'test_helper'

class ResearchControllerTest < ActionController::TestCase
  test "should get others" do
    get :others
    assert_response :success
  end

  test "should get swot" do
    get :swot
    assert_response :success
  end

  test "should get comparison" do
    get :comparison
    assert_response :success
  end

end
