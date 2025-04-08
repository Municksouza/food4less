require "test_helper"

class StoreDashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @store_manager = store_managers(:one) # Assumindo que você tenha um fixture
    sign_in @store_manager
  end

  test "should get show" do
    get stores_dashboard_path # Ensure this matches the correct route helper for the 'show' action
    assert_response :success
  end
end