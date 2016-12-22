require 'test_helper'

class GatekeepersControllerTest < ActionController::TestCase
  setup do
    @gatekeeper = gatekeepers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gatekeepers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gatekeeper" do
    assert_difference('Gatekeeper.count') do
      post :create, gatekeeper: { name: @gatekeeper.name }
    end

    assert_redirected_to gatekeeper_path(assigns(:gatekeeper))
  end

  test "should show gatekeeper" do
    get :show, id: @gatekeeper
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gatekeeper
    assert_response :success
  end

  test "should update gatekeeper" do
    patch :update, id: @gatekeeper, gatekeeper: { name: @gatekeeper.name }
    assert_redirected_to gatekeeper_path(assigns(:gatekeeper))
  end

  test "should destroy gatekeeper" do
    assert_difference('Gatekeeper.count', -1) do
      delete :destroy, id: @gatekeeper
    end

    assert_redirected_to gatekeepers_path
  end
end
