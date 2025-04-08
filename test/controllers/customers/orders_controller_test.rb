require "test_helper"

class Customers::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  

  fixtures :orders, :stores, :customers

  setup do
    @customer = customers(:one)
    sign_in @customer
  end

  test "should get index" do
    get customers_orders_url
    assert_response :success
  end

  test "should show order" do
    order = orders(:one)
    get customers_order_url(order)
    assert_response :success
  end

  test "should create order" do
    sign_in customers(:one)
  
    assert_difference('Order.count', 1) do
      post customers_orders_url, params: {
        order: {
          store_id: stores(:one).id,
          total_price: 10.50,
          status: "pending",
        }
      }
    end
  
    assert_redirected_to customers_orders_path(Order.last)
  end
end