# test/controllers/stores_controller_test.rb
require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :business_admins, :stores

  def setup
    @business_admin = BusinessAdmin.create!(
      name: "Admin Teste",
      address: "Rua Teste, 123",
      phone: "123456789",
      zip_code: "12345-678",
      logo: fixture_file_upload(Rails.root.join("test", "fixtures", "files", "placeholder.jpeg"), "image/png"),
      email: "admin@example.com",
      password: "password123"
    )
  
    @store = Store.create!(
      name: "Loja Teste",
      email: "store@example.com",
      phone: "123456789",
      address: "Rua Teste, 123",
      zip_code: "12345-678",
      description: "Loja de teste",
      logo: fixture_file_upload(Rails.root.join("test", "fixtures", "files", "placeholder.jpeg"), "image/png"),
      business_admin: @business_admin,
      status: "active"
    )
  
    sign_in @business_admin, scope: :business_admin
  end

  test "should get index" do
    get stores_url
    assert_response :success
  end

  test "should show store" do
    get store_url(@store)
    assert_response :success
  end
end