require "test_helper"
include Warden::Test::Helpers

class BusinessAdmins::OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @business_admin = FactoryBot.create(:business_admin)
    @store = FactoryBot.create(:store, business_admin: @business_admin)
    sign_in @business_admin, scope: :business_admin  
  end

  test "should get index" do
    get business_admins_store_orders_path(@store.slug)
    assert_response :success
  end
end