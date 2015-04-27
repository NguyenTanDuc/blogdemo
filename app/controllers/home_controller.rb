class HomeController < ApplicationController
  def index
    if is_logged_in?
      @entry  = current_user.entries.build
      @feed_items = current_user.feed.paginate(page: params[:page],per_page: 10)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
