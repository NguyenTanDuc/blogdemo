class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]

	def create
		@comment = current_user.comments.build(comment_params)
		if @comment.save
			flash[:success] = "Comment created"
			redirect_to @comment.entry
		else
			render 'entries/show'
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		if current_user?(@comment.user) && @comment.destroy
			flash[:success] = "Comment deleted"
			redirect_to @comment.entry
		else
			redirect_to root_path
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:content, :entry_id)
		end
end
