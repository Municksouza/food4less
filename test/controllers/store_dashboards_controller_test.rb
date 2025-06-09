class StoreDashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    Rails.application.env_config["action_dispatch.show_exceptions"] = true
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false

    @store_manager = store_managers(:one)
    sign_in @store_manager
  end

  test "should get show" do
    get store_managers_area_store_dashboard_path(slug: store_managers(:one).store.slug)    
    assert_response :success
  end
end