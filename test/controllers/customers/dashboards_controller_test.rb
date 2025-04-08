require "test_helper"

class Customers::DashboardsControllerTest < ActionDispatch::IntegrationTest  
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  setup do
    Rails.application.reload_routes!
    @customer = customers(:one) # Assuming you have a fixture for customers
    sign_in @customer
  end

  test "should get show" do
    get Rails.application.routes.url_helpers.customers_dashboard_path    
    assert_response :success
  end
end
