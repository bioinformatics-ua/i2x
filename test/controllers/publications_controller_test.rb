require 'test_helper'

class PublicationsControllerTest < ActionController::TestCase
  test "should get automating" do
    get :automating
    assert_response :success
  end

  test "should get wave" do
    get :wave
    assert_response :success
  end

  test "should get framework" do
    get :framework
    assert_response :success
  end

  test "should get template" do
    get :template
    assert_response :success
  end

  test "should get semantic" do
    get :semantic
    assert_response :success
  end

  test "should get rule" do
    get :rule
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
