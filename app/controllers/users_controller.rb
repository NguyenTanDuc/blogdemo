class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :following, :followers]

	def index
		@users = User.paginate(page: params[:page], per_page: 10)
	end

	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@entries = @user.entries.paginate(page: params[:page],per_page: 10)
	end

	def create
		@user = User.new(user_params)
		if @user.save
			@user.send_activation_email
			flash[:info] = "Please check your email to activate your account"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def following
	    @title = "Following"
	    @user  = User.find(params[:id])
	    @users = @user.following.paginate(page: params[:page], per_page: 10)
	    render 'show_follow'
	end

	def followers
	    @title = "Followers"
	    @user  = User.find(params[:id])
	    @users = @user.followers.paginate(page: params[:page], per_page: 10)
	    render 'show_follow'
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def logged_in_user
			unless is_logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_users_path
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end
end
