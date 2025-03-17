require "test_helper"

class StoreDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get store_dashboards_show_url
    assert_response :success
  end
end
