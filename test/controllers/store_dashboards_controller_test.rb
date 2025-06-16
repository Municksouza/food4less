require "test_helper"

class StoreDashboardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @store = FactoryBot.create(:store)
    @store_manager = FactoryBot.create(:store_manager, store: @store)
    
    sign_in @store_manager
  end

  test "should get show" do
    get store_managers_area_store_dashboard_path(@store.slug)
    assert_response :success
  end
end