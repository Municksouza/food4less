require "test_helper"

class Customers::CartsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  setup do
    @customer = customers(:one) || Customer.create!(
      name: "Test Customer",
      email: "customer@example.com",
      phone: "1234567890",
      password: "password123"
    )
    @customer.confirm if @customer.respond_to?(:confirm)
    sign_in @customer

    @business_admin = business_admins(:one) || BusinessAdmin.create!(
      name: "Test Business Admin",
      address: "123 Test St",
      zip_code: "12345",
      phone: "1234567890",
      email: "business@exemple.com",
      password: "password123"
    )
    @business_admin.confirm if @business_admin.respond_to?(:confirm)
    sign_in @business_admin
    @store_manager = store_managers(:one) || StoreManager.create!(
      name: "Test Store Manager",
      address: "123 Test St",
      zip_code: "12345",
      phone: "1234567890",
      email: "store_manager@exemple.com",
      password: "password123",
      logo: fixture_file_upload(Rails.root.join("test/fixtures/files/placeholder.jpeg"), "image/png")
    )
    @store_manager.confirm if @store_manager.respond_to?(:confirm)
    sign_in @store_manager

    @store = stores(:one) || Store.create!(
      name: "Test Store",
      address: "123 Test St",
      zip_code: "12345",
      phone: "1234567890", 
      email: "store@example.com",
      status: "active",
      description: "A test store"
    )
    @store.confirm if @store.respond_to?(:confirm)

    @product = Product.create!(
      name: "Test Product",
      price: 10.0,
      stock: 10,
      description: "A test product",
      store: @store,
      category: Category.create!(
        name: "Test",
      ),
    )

  end

  
  test "should add item to cart" do
    post "/customers/cart/add_item", params: { product_id: @product.id }
    assert_redirected_to "/customers/cart"
    assert_equal "Product added to cart.", flash[:notice]
  end

  test "should remove item from cart" do
    post "/customers/cart/add_item", params: { product_id: @product.id }
    delete "/customers/cart/remove_item", params: { product_id: @product.id }
    assert_redirected_to "/customers/cart"
  end

  test "should update item quantity" do
    post "/customers/cart/add_item", params: { product_id: @product.id }
    patch "/customers/cart/update_item", params: { product_id: @product.id, quantity: 3 }
    assert_redirected_to "/customers/cart"
  end

  test "should clear cart" do
    post "/customers/cart/add_item", params: { product_id: @product.id }
    delete "/customers/cart/clear_cart"
    assert_redirected_to  customers_cart_path
  end

  test "should not add nonexistent product" do
    post "/customers/cart/add_item", params: { product_id: 9999 }
    assert_redirected_to "/"
    assert_equal "Product not found.", flash[:alert]
  end
end