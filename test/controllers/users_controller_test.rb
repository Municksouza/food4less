# require "test_helper"

# class UsersControllerTest < ActionDispatch::IntegrationTest
#   test "should get index" do
#     get users_url
#     assert_response :success
#   end

#   test "should get edit" do
#     user = users(:one) # Certifique-se de ter um fixture chamado :one
#     get edit_user_url(user)
#     assert_response :success
#   end

#   test "should update user" do
#     user = users(:one)
#     patch user_url(user), params: { user: { name: "Updated Name" } }
#     assert_redirected_to users_url
#   end

#   test "should destroy user" do
#     user = users(:one)
#     delete user_url(user)
#     assert_redirected_to users_url
#   end
# end