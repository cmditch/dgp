require 'test_helper'

class BitpayWebhooksControllerTest < ActionController::TestCase
  setup do
    @bitpay_webhook = bitpay_webhooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bitpay_webhooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bitpay_webhook" do
    assert_difference('BitpayWebhook.count') do
      post :create, bitpay_webhook: { data: @bitpay_webhook.data }
    end

    assert_redirected_to bitpay_webhook_path(assigns(:bitpay_webhook))
  end

  test "should show bitpay_webhook" do
    get :show, id: @bitpay_webhook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bitpay_webhook
    assert_response :success
  end

  test "should update bitpay_webhook" do
    patch :update, id: @bitpay_webhook, bitpay_webhook: { data: @bitpay_webhook.data }
    assert_redirected_to bitpay_webhook_path(assigns(:bitpay_webhook))
  end

  test "should destroy bitpay_webhook" do
    assert_difference('BitpayWebhook.count', -1) do
      delete :destroy, id: @bitpay_webhook
    end

    assert_redirected_to bitpay_webhooks_path
  end
end
