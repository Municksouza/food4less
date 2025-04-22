require "test_helper"

class Customers::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers  

  fixtures :orders, :stores, :customers, :products

  setup do
    @store   = stores(:one)
    @product = products(:one)
    sign_in customers(:one)
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
    assert_difference "Order.count", 1 do
      post customers_orders_url, params: {
        store_id:         @store.id,
        ready_in_minutes: 20,
        order_items_attributes: {
          "0" => {
            product_id:  @product.id,
            unit_price:  @product.price,
            quantity:    2
          }
        }
      }
    end

    assert_redirected_to customers_orders_path
  end
end