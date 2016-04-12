class Api::V1::UsersController < ApplicationController
	before_action :authenticate_with_token!, only: [:update, :destroy]
	respond_to :json

	def index
		respond_with User.all
	end

	def show
		respond_with User.find(params[:id])
	end

	def create
		user = User.new(user_params)
		if user.save
			render json: user, status: 201, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422
		end
	end

	def update
		user = User.find(params[:id])

		if !current_user? user
			render json: { errors: "Not authorized to delete other users"}, status: 401
		elsif user.update(user_params)
			render json: user, status: 200, location: [:api, user]
		else
			render json: { errors: user.errors}, status: 422
		end
	end

	def destroy
		user = User.find(params[:id])
		if !current_user?(user)
			render json: { errors: "Not authorized to delete other users"}, status: 401
		else
			user.destroy
			head 204
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end