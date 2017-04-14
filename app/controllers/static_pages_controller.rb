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

  def photo
    @page_title = 'Nostalgia'
    @memory_json = Memory.first.to_builder.target!
  end
end
