# test/controllers/stores_controller_test.rb
require "test_helper"

class StoresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @business_admin = BusinessAdmin.create!(
      name: "Admin Teste",
      address: "Rua Teste, 123, Mountain View, CA",
      phone: "123456789",
      zip_code: "94043",
      logo: fixture_file_upload(Rails.root.join("test", "fixtures", "files", "placeholder.jpeg"), "image/png"),
      email: "admin@example.com",
      password: "Password1!",  # Senha para BusinessAdmin, se necessário
      business_number: "123456901"
    )

   @store = Store.create!(
    name: "Loja Teste",
    email: "store@example.com",
    phone: "123456789",
    address: "123 Main St, Saskatoon, SK",
    zip_code: "S7K 1N2",
    description: "Loja de teste",
    logo: fixture_file_upload(Rails.root.join("test", "fixtures", "files", "placeholder.jpeg"), "image/png"),
    business_admin: @business_admin,
    status: "active"
  )

    sign_in @business_admin, scope: :business_admin
  end

  test "should get index" do
    get stores_url, as: :html
    assert_response :success
  end

  test "should show store" do
    get store_url(@store), as: :html
    assert_response :success
  end
end