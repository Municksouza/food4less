require "test_helper"

class Customers::ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_reviews_index_url
    assert_response :success
  end

  test "should get destroy" do
    get customers_reviews_destroy_url
    assert_response :success
  end
end
