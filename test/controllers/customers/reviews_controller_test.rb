require "test_helper"

class Customers::ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @customer = FactoryBot.create(:customer)
    sign_in @customer
    @review = FactoryBot.create(:review, customer: @customer)
  end

  test "should get index" do
    get customers_reviews_path
    assert_response :success
  end

  test "should get destroy" do
    delete customers_review_path(@review)
    assert_redirected_to customers_reviews_path
  end
end