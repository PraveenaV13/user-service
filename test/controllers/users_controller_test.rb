require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    @test_user = users(:editor_user)
    @token = JsonWebToken.encode(user_id: @user.id)
  end

  test "should get index" do
    get users_url, 
        headers: { 'Authorization' => "Bearer #{@token}" }
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url,
      params: { user: {email: 'praveena@example.com', password: '123456', password_confirmation: '123456'} }, as: :json
    end
    response_body = JSON.parse(@response.body)

    assert_response :created
    assert response_body.key?("token")
    assert response_body.key?("user")
  end

  test "should not create user without email" do
    assert_no_difference("User.count") do
      post users_url,
      params: { user: {email: '', password: '', password_confirmation: ''} }, as: :json
    end

    response_body = JSON.parse(@response.body)

    assert_response :unprocessable_entity
    assert_includes(response_body["errors"], "Password can't be blank")
    assert_includes(response_body["errors"], "Email can't be blank")
  end

  test "should show user only for admin role" do
    get user_url(@test_user),
        headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    response_body = JSON.parse(@response.body)

    assert_response :success
    assert_equal response_body["email"], @test_user.email
  end

  test "should not show user for other roles" do
    token = JsonWebToken.encode(user_id: @test_user.id)

    get user_url(@user),
        headers: { 'Authorization' => "Bearer #{token}" }, as: :json

    response_body = JSON.parse(@response.body)

    assert_response :forbidden
    assert_equal response_body["error"], "You are not authorized to access this page."
  end

  test "profile should show logged-in user details" do
    get profile_users_url,
        headers: { 'Authorization' => "Bearer #{@token}" }, as: :json

    response_body = JSON.parse(@response.body)

    assert_response :success
    assert_equal response_body["email"], @user.email
  end

  # test "should update user" do
  #   patch user_url(@user), params: { user: {} }, as: :json
  #   assert_response :success
  # end

  # test "should destroy user" do
  #   assert_difference("User.count", -1) do
  #     delete user_url(@user), as: :json
  #   end

  #   assert_response :no_content
  # end
end
