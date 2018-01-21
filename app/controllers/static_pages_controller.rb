class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to memories_path
    else
      @memory_json = Memory.find_by(name: "Joe's Boat").to_builder.target!
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

  def letsencrypt
    if params[:id].match /yysef/
      render text: "yysef78qwgdDBZJoN6FEx2oCJrIeCCF6XKByFQR0njQ.y8WTLTOwWWbA4olBERIK4CspJS7ZCK6dcZfOO2kgCP8"
    else
      render text: "Bv58Dk9Pudj82oAyBwScNIKkbJ1nBEVSakWh1UOjW8g.y8WTLTOwWWbA4olBERIK4CspJS7ZCK6dcZfOO2kgCP8"
    end
  end
end
