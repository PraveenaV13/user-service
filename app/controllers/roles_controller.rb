class RolesController < ApplicationController

  # GET /roles
	def index
		@roles = Role.all
		render json: @roles
	end

	# POST /roles
	def create
		@role = Role.new(role_params)

		if @role.save
		  render json: @role, status: :created, location: @user
		else
		   render json: @role.errors, status: :unprocessable_content
		end
	end

	private

	def role_params
		params.require(:role).permit(:name)
	end
end
