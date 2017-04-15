  class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
    @page_title = 'Help'
  end

  def about
    @page_title = 'About'
  end

  def contact
    @page_title = 'Contact'
  end

  def signup
    @page_title = 'Sign up'
  end

  def demo
    @memory_json = Memory.second.to_builder.target!
    render :memory
  end
end
