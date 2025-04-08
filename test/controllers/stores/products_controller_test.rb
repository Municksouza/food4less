# test/controllers/store/products_controller_test.rb
require "test_helper"

module Stores
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    def setup
      @store_manager = store_managers(:one)
      sign_in @store_manager
      @store = @store_manager.store

      @product = @store.products.create!(
        name: "Existing Product",
        description: "Test product",
        price: 10.0,
        old_price: 15.0,
        stock: 5
      )
    end

    test "should get index" do
      get stores_products_url
      assert_response :success
    end

    test "should get new" do
      get new_stores_product_url
      assert_response :success
    end

    test "should create product" do
      assert_difference("Product.count", 1) do
        post stores_products_url, params: {
          product: {
            name: "New Product",
            description: "Created from test",
            price: 12.0,
            old_price: 20.0,
            stock: 10
          }
        }
      end
      assert_redirected_to stores_products_path
    end

    test "should show product" do
      get stores_product_url(@product)
      assert_response :success
    end

    test "should get edit" do
      get edit_stores_product_url(@product)
      assert_response :success
    end

    test "should update product" do
      patch stores_product_url(@product), params: {
        product: {
          name: "Updated Product"
        }
      }
      assert_redirected_to stores_products_path
    end

    test "should destroy product" do
      assert_difference("Product.count", -1) do
        delete stores_product_url(@product)
      end
      assert_redirected_to stores_products_path
    end
  end
end