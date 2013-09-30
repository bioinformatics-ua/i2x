require 'test_helper'

class StdsControllerTest < ActionController::TestCase
  setup do
    @std = stds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create std" do
    assert_difference('Std.count') do
      post :create, std: { help: @std.help, key: @std.key, label: @std.label, visited: @std.visited }
    end

    assert_redirected_to std_path(assigns(:std))
  end

  test "should show std" do
    get :show, id: @std
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @std
    assert_response :success
  end

  test "should update std" do
    patch :update, id: @std, std: { help: @std.help, key: @std.key, label: @std.label, visited: @std.visited }
    assert_redirected_to std_path(assigns(:std))
  end

  test "should destroy std" do
    assert_difference('Std.count', -1) do
      delete :destroy, id: @std
    end

    assert_redirected_to stds_path
  end
end
