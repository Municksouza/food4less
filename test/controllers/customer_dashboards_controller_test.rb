require "test_helper"

class CustomerDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customer_dashboards_show_url
    assert_response :success
  end
end
