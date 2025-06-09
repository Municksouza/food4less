# test/controllers/stores/products_controller_test.rb
require "test_helper"

module StoreManagersArea
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :store_managers, :stores, :categories, :products

    def setup
      @manager = store_managers(:one)
      sign_in @manager
      @store = @manager.store
      @category = categories(:one)

      @product = @store.products.create!(
        name: "Existing Product",
        description: "Test product",
        price: 10.0,
        old_price: 15.0,
        stock: 5,
        category: @category
      )
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