require "test_helper"

class BusinessAdmins::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    host! "www.example.com"

    @business_admin = business_admins(:one) # Make sure the fixture is correct
    sign_in @business_admin

    @store = stores(:one) # The store associated with the business_admin
    @order = orders(:one) # An existing order in this store
  end

  test "should get index" do
    get business_admins_store_orders_url(@store)
    assert_response :success
  end

  test "should show order" do
    get business_admins_store_order_url(@store, @order)
    assert_response :success
  end

  test "should approve order" do
    patch approve_business_admins_store_order_path(@store, @order)
    @order.reload
    puts @order.errors.full_messages # Debugging: Log validation errors
    assert_equal "approved", @order.status, "Order status was not updated to 'approved'"
    assert_redirected_to business_admins_store_orders_path(@store)
    follow_redirect!
    assert_match "Order successfully approved.", response.body
  end

  test "should reject order" do
    patch reject_business_admins_store_order_path(@store, @order)
    @order.reload
    assert_equal "rejected", @order.status
  end

end