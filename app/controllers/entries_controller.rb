class EntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

	def create
		@entry = current_user.entries.build(entry_params)
		if @entry.save
			flash[:success] = "Entry created"
			redirect_to root_path
		else
			@feed_items = []
			render 'home/index'
		end
	end

	def show
		@entry = Entry.find(params[:id])
		@user = User.find(@entry.user_id)
		if is_logged_in?
			@comment = Comment.new(user_id: current_user.id, entry_id: @entry.id)
		end
		@comments = @entry.comments.paginate(page: params[:page],per_page: 10)
	end

	def destroy
		@entry.destroy
	    flash[:success] = "Entry deleted"
	    redirect_to request.referrer || root_url
	end

	private
	    def entry_params
	      params.require(:entry).permit(:title,:body)
	    end

	    def correct_user
	      @entry = current_user.entries.find_by(id: params[:id])
	      redirect_to root_url if @entry.nil?
	    end
end
