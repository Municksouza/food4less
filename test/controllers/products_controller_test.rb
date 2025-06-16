require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @product = FactoryBot.create(:product)
  end
  
  test "should get show" do
    get product_path(@product)
    assert_response :success
  end
end