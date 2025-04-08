require "test_helper"

class Stores::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @store_manager = store_managers(:one) # ou crie com FactoryBot
    sign_in @store_manager
    @order = orders(:one)
  end

  test "should get index" do
    get stores_orders_url
    assert_response :success
  end

  test "should approve order" do
    patch approve_stores_order_url(@order)
    assert_redirected_to stores_orders_url
  end

  test "should reject order" do
    patch reject_stores_order_url(@order)
    assert_redirected_to stores_orders_url
  end
end