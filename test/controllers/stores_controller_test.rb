 require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @business_admin = FactoryBot.create(:business_admin)
    sign_in @business_admin, scope: :business_admin
    @store = FactoryBot.create(:store, business_admin: @business_admin)
  end

  test "should show store" do
    get store_path(@store.slug)
    assert_response :success
  end
end