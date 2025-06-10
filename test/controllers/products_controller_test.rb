require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  fixtures :products

  def setup
    @product = products(:one)
  end
  
  test "should get show" do
    product = products(:one) 
    get products_url(product)                           
    assert_response :success
  end
end
