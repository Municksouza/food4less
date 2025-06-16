require "test_helper"

class Customers::DashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = FactoryBot.create(:customer)
    sign_in @customer
  end

  test "should get dashboard" do
    get customers_dashboard_path
    assert_response :success
  end
end