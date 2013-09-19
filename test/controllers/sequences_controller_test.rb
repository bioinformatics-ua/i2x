require 'test_helper'

class SequencesControllerTest < ActionController::TestCase
  test "should get diff" do
    get :diff
    assert_response :success
  end

  test "should get content" do
    get :content
    assert_response :success
  end

  test "should get tules" do
    get :tules
    assert_response :success
  end

  test "should get template" do
    get :template
    assert_response :success
  end

  test "should get full" do
    get :full
    assert_response :success
  end

end
