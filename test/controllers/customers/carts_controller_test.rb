# test/controllers/customers/carts_controller_test.rb
require "test_helper"

class Customers::CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = FactoryBot.create(:customer)
    sign_in @customer
  end

  test "should show cart" do
    get customers_cart_path
    assert_response :success
  end
end