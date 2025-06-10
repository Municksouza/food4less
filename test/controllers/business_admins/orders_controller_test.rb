require "test_helper"

class BusinessAdmins::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    Refund.delete_all
    OrderStatus.delete_all
    OrderItem.delete_all
    OrderHistory.delete_all
    Payment.delete_all
    Receipt.delete_all
    Review.delete_all
    Order.delete_all
     # Reset the database to ensure a clean state for each test     
    unique_business_number = loop do
      number = rand(100_000_000..999_999_999).to_s
      break number unless BusinessAdmin.exists?(business_number: number)
    end

    @business_admin = BusinessAdmin.create!(
      name: "Admin Test",
      phone: "1234567890",
      email: "admin_test_#{SecureRandom.hex(4)}@example.com",
      address: "1128 McKercher Dr, Saskatoon, SK S7H 4Y7",
      zip_code: "S7H 4Y7",
      business_number: unique_business_number, # ✅ 9 dígitos, guaranteed unique
      password: "Test123!"
    )

    @store = Store.create!(
      name: "Store Test",
      email: "store_test_#{SecureRandom.hex(4)}@example.com",
      phone: "1234567890",
      address: "1128 McKercher Dr, Saskatoon, SK S7H 4Y7", # same as the stub!
      zip_code: "S7H 4Y7",
      description: "Test store",
      logo: fixture_file_upload(Rails.root.join("test/fixtures/files/placeholder.jpeg"), "image/jpeg"),
      business_admin: @business_admin,
      status: "active"
    )

    @customer = Customer.create!(
      name: "Customer Test",
      phone: "1234567890",
      email: "customer_#{SecureRandom.hex(4)}@example.com",
      password: "Password1!"
    )

    @order = Order.create!(
      store: @store,
      customer: @customer,
      status: "pending",
      total_price: 29.99,
      total_amount: 29.99
    )

    sign_in @business_admin
  end

  test "should get index" do
    get business_admins_store_orders_path(@store.slug)
    assert_response :success
  end

  test "should approve order" do
    patch approve_business_admins_store_order_path(@store.slug, @order)
    follow_redirect!
    assert_match /Order successfully approved/, response.body
  end
end