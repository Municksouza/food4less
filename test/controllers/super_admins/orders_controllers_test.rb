require "test_helper"

class SuperAdmins::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @super_admin = super_admins(:one)
    sign_in @super_admin
    @order = orders(:one)
  end

  test "should get index" do
    get super_admins_orders_url
    assert_response :success
  end

  test "should approve order" do
    patch approve_super_admins_order_url(@order)
    assert_redirected_to super_admins_orders_url
  end

  test "should reject order" do
    patch reject_super_admins_order_url(@order)
    assert_redirected_to super_admins_orders_url
  end
end