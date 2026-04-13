class SessionsController < ApplicationController
	skip_before_action :authenticate_user, only: [:create]

	# Login (Generate JWT)
	def create
		user = User.find_by(email: params[:email])
		if user&.authenticate(params[:password])
			token = JsonWebToken.encode(user_id: user.id)
			render json: { token: token }, status: :ok
		else
			render json: { error: "Invalid credentials" }, status: :unauthorized
		end
	end

	# Logout
	def destroy
		render json: { message: "Logged out successfully" }, status: :ok
	end
end