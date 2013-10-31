require 'test_helper'

class IntegrationsControllerTest < ActionController::TestCase
  setup do
    @integration = integrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:integrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create integration" do
    assert_difference('Integration.count') do
      post :create, integration: { help: @integration.help, identifier: @integration.identifier, memory: @integration.memory, payload: @integration.payload, title: @integration.title }
    end

    assert_redirected_to integration_path(assigns(:integration))
  end

  test "should show integration" do
    get :show, id: @integration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @integration
    assert_response :success
  end

  test "should update integration" do
    patch :update, id: @integration, integration: { help: @integration.help, identifier: @integration.identifier, memory: @integration.memory, payload: @integration.payload, title: @integration.title }
    assert_redirected_to integration_path(assigns(:integration))
  end

  test "should destroy integration" do
    assert_difference('Integration.count', -1) do
      delete :destroy, id: @integration
    end

    assert_redirected_to integrations_path
  end
end
