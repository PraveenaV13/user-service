class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  skip_before_action :authenticate_user, only: [:create]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: {token: token, user: @user}, status: :created
      # render json: @user, status: :created, location: @user # This created location header in response. Tells where the newly created record can be found
    else
      # render json: @user.errors, status: :unprocessable_content
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_content
    end
  end

  def profile
    render json: { name: @current_user.name, email: @current_user.email, last_signed_in: @current_user.last_signed_in }
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # strong parameters are needed to protect app from mass assignment vulnerabilities. Without them, a malicious user cound send extra 
    # extra fields in a form or JSON payload. Explicitly whitelist which attributes can be set from user input.
end
