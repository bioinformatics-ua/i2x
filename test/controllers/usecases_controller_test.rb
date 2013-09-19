require 'test_helper'

class UsecasesControllerTest < ActionController::TestCase
  test "should get variome" do
    get :variome
    assert_response :success
  end

  test "should get management" do
    get :management
    assert_response :success
  end

  test "should get medical" do
    get :medical
    assert_response :success
  end

  test "should get newborn" do
    get :newborn
    assert_response :success
  end

  test "should get crm" do
    get :crm
    assert_response :success
  end

end
