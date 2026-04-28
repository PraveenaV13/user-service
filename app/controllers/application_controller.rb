class ApplicationController < ActionController::API
	before_action :authenticate_user
	include CanCan::ControllerAdditions

	attr_reader :current_user

	rescue_from CanCan::AccessDenied do |exception|
		render json: { error: exception.message }, status: :forbidden
	end

	private
	def authenticate_user
		header = request.headers['Authorization']
		token = header.split(' ').last if header
		decoded = JsonWebToken.decode(token)
		if decoded
			@current_user = User.find_by(id: decoded[:user_id])
		else
			render json: { error: "Unauthorized" }, status: :unauthorized
		end
	end
end
