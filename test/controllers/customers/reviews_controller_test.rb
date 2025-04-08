require "test_helper"

class Customers::ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @customer = customers(:one) # certifique-se de ter um fixture de customer
    sign_in @customer
  end

  test "should get index" do
    get customers_reviews_url
    assert_response :success
  end

  test "should get destroy" do
    review = reviews(:one) # Assumindo que você tem um fixture chamado "one"
    delete customers_review_url(review)
    assert_redirected_to customers_reviews_path  
  end
end