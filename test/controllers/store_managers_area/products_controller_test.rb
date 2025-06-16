# test/controllers/store_managers_area/products_controller_test.rb
require "test_helper"

module StoreManagersArea
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      Faker::UniqueGenerator.clear
      @store = create(:store, receive_notifications: false)  
      @store_manager = create(:store_manager, store: @store, password: "Senha123!") 
      sign_in @store_manager, scope: :store_manager

      @category = create(:category)
      @product = create(:product, store: @store, category: @category)
    end

    test "should get index" do
      get store_managers_area_products_path(slug: @store.slug)
      assert_response :success
    end

    test "should get new" do
      get new_store_managers_area_product_path(slug: @store.slug)
      assert_response :success
    end

    test "should create product" do
      assert_difference("Product.count", 1) do
        post store_managers_area_products_path(slug: @store.slug), params: {
          product: {
            name: "New Product",
            description: "Created from test",
            price: 12.0,
            old_price: 20.0,
            stock: 10,
            category_id: @category.id
          }
        }
      end
      assert_redirected_to store_managers_area_products_path(slug: @store.slug)
    end

    test "should show product" do
      get store_managers_area_product_path(@product, slug: @store.slug)
      assert_response :success
    end

    test "should get edit" do
      get edit_store_managers_area_product_path(@product, slug: @store.slug)
      assert_response :success
    end

    test "should update product" do
      patch store_managers_area_product_path(@product, slug: @store.slug), params: {
        product: {
          name: "Updated Product"
        }
      }
      assert_redirected_to store_managers_area_products_path(slug: @store.slug)
    end

    test "should destroy product" do
      assert_difference("Product.count", -1) do
        delete store_managers_area_product_path(@product, slug: @store.slug)
      end
      assert_redirected_to store_managers_area_products_path(slug: @store.slug)
    end
  end
end