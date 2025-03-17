require "test_helper"

class SuperAdminDashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get super_admin_dashboards_show_url
    assert_response :success
  end
end
