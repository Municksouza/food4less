# test/controllers/store_managers_area/orders_controller_test.rb
require "test_helper"

module StoreManagersArea
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :store_managers, :stores, :customers, :orders

    def setup
      @manager = store_managers(:one)
      sign_in @manager
      @store = @manager.store
      @order = orders(:one)
    end

    test "should get index" do
      get store_managers_area_orders_path(slug: @store.slug)
      assert_response :success
    end

    test "should approve order" do
      patch approve_store_managers_area_order_path(@order, slug: @store.slug)
      assert_redirected_to store_managers_area_orders_path(slug: @store.slug)
    end

    test "should reject order" do
      patch reject_store_managers_area_order_path(@order, slug: @store.slug)
      assert_redirected_to store_managers_area_orders_path(slug: @store.slug)
    end
  end
end