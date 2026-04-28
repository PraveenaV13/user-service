require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user with proper email and password" do
    user = User.new(name: "Praveena", email: "test@example.com", password: "password")
    assert user.valid?
  end

  test "invalid without email and password" do
    user = User.new(name: "Praveena", email: "", password: "")
    
    assert_not user.valid?
    assert_includes user.errors.to_hash[:email], "can't be blank"
    assert_includes user.errors.to_hash[:password], "can't be blank"
  end

end
