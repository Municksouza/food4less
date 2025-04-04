require "test_helper"

class Customers::CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customers_carts_show_url
    assert_response :success
  end

  test "should get add_item" do
    get customers_carts_add_item_url
    assert_response :success
  end

  test "should get remove_item" do
    get customers_carts_remove_item_url
    assert_response :success
  end

  test "should get update_item" do
    get customers_carts_update_item_url
    assert_response :success
  end

  test "should get clear_cart" do
    get customers_carts_clear_cart_url
    assert_response :success
  end

  test "should get checkout" do
    get customers_carts_checkout_url
    assert_response :success
  end
end
