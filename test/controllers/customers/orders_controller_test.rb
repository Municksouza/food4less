# test/controllers/customers/orders_controller_test.rb
require "test_helper"

class Customers::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = FactoryBot.create(:customer)
    @store = FactoryBot.create(:store)
    @product = FactoryBot.create(:product, store: @store)
    sign_in @customer, scope: :customer
  end

  test "should get index" do
    get customers_orders_path
    assert_response :success
  end
end
