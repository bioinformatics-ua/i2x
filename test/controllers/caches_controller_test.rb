require 'test_helper'

class CachesControllerTest < ActionController::TestCase
  setup do
    @cach = caches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:caches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cach" do
    assert_difference('Cache.count') do
      post :create, cach: { agent: @cach.agent, hash: @cach.hash, memory: @cach.memory, payload: @cach.payload, publisher: @cach.publisher }
    end

    assert_redirected_to cach_path(assigns(:cach))
  end

  test "should show cach" do
    get :show, id: @cach
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cach
    assert_response :success
  end

  test "should update cach" do
    patch :update, id: @cach, cach: { agent: @cach.agent, hash: @cach.hash, memory: @cach.memory, payload: @cach.payload, publisher: @cach.publisher }
    assert_redirected_to cach_path(assigns(:cach))
  end

  test "should destroy cach" do
    assert_difference('Cache.count', -1) do
      delete :destroy, id: @cach
    end

    assert_redirected_to caches_path
  end
end
