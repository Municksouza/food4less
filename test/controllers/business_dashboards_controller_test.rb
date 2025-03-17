require "test_helper"

class BusinessDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get business_dashboards_show_url
    assert_response :success
  end
end
