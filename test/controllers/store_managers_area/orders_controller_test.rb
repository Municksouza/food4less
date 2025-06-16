require "test_helper"

class StoreManagersArea::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @store = FactoryBot.create(:store)
    @store_manager = FactoryBot.create(:store_manager, store: @store, password: "Password1!")
    sign_in @store_manager, scope: :store_manager
    @order = FactoryBot.create(:order, store: @store)
  end

  test "should get index" do
    get store_managers_area_orders_path
    assert_response :success
  end
end