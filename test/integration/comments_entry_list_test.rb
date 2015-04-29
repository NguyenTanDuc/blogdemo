require 'test_helper'

class CommentsEntryListTest < ActionDispatch::IntegrationTest

	def setup
		@entry = entries(:two)
		
	end

	test "list comment display" do
		get entry_path(@entry)
		assert_template 'entries/show'
		assert_match @entry.comments.count.to_s, response.body
		@entry.comments.paginate(page: 1, per_page: 10).each do |comment|
			assert_match comment.content, response.body
		end
	end
end
