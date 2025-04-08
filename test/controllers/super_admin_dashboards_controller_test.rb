require "test_helper"

class SuperAdminDashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @super_admin = super_admins(:one)
    sign_in @super_admin
  end

  test "should get show" do
    get super_admins_dashboard_url
    assert_response :success
  end
end