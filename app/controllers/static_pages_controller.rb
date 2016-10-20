class StaticPagesController < ApplicationController
  def home
    @page_title = 'Home'
  end

  def help
    @page_title = 'Help'
  end

  def about
    @page_title = 'About'
  end
end
