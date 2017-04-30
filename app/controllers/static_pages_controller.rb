  class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @memories = current_user.memories
    else
      @body_class = 'demo'
      @memory_json = Memory.second.to_builder.target!
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
  end
end
