require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    post customers_payments_url    
    assert_response :success
  end
end
