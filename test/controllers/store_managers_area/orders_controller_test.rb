require "test_helper"

class StoreManagersArea::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Limpa todas as tabelas relevantes
    [CartItem, OrderHistory, Refund, OrderItem, Order, Product, Cart,
    StoreManager, Store, Customer, BusinessAdmin].each(&:destroy_all)

    # Cria BusinessAdmin
    business_admin = BusinessAdmin.create!(
      name: "BA",
      address: "Test",
      zip_code: "S7H 4Y7",
      phone: "1234567890",
      email: "ba_#{SecureRandom.hex(4)}@test.com",
      business_number: rand(100_000_000..999_999_999).to_s,
      password: "Password1!"
    )

    # Cria Store (precisa vir antes do StoreManager e Order!)
    @store = Store.create!(
      name: "Test Store",
      address: "123 Test St",
      email: "store_#{SecureRandom.hex(4)}@example.com",
      zip_code: "S7H 4Y7",
      phone: "1234567890",
      status: "active",
      description: "Test store",
      business_admin: business_admin,
      logo: fixture_file_upload(Rails.root.join("test/fixtures/files/placeholder.jpeg"), "image/jpeg"),
      slug: "test-store-#{SecureRandom.hex(2)}"
    )

    # Cria StoreManager com store associada
    @store_manager = StoreManager.create!(
      email: "store_manager_#{SecureRandom.hex(4)}@example.com",
      password: "Password1!",
      receive_notifications: true,
      store: @store
    )

    # Cria Customer
    @customer = Customer.create!(
      name: "One",
      email: "customer_#{SecureRandom.hex(4)}@example.com",
      phone: "1234567890",
      password: "Password1!"
    )

    # Cria Order
    @order = Order.create!(
      store: @store,
      customer: @customer,
      status: "pending",
      total_price: 20.0,
      total_amount: 20.0
    )

    # Autentica StoreManager
    sign_in @store_manager
  end

  test "should get index" do
    get store_managers_area_orders_path
    assert_response :success
  end

  
  test "should approve order" do
    patch approve_store_managers_area_order_path(@order), params: {
      order: {
        ready_in_minutes: 10
      },
      slug: @order.store.slug
    }

    assert_redirected_to store_managers_area_orders_path(slug: @order.store.slug)
    follow_redirect!
    assert_match /Order approved successfully/, response.body
  end

  test "should reject order" do
    patch reject_store_managers_area_order_path(@order)
    follow_redirect!
    assert_match /Order rejected/, response.body
  end
end