require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  fixtures :products
  test "should get show" do
    product = products(:one) 
    get product_url(product)                           
    assert_response :success
  end
end
