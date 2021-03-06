class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to memories_path
    else
      @memory_json = Memory.find_by(name: "Joe's Boat").to_builder.target!
    end
  end

  def about
    @page_title = 'About'
  end

  def contact_success
    flash[:notice] = "Thanks for the feedback!"
    redirect_to root_path
  end

  def letsencrypt
    if params[:id].match /yysef/
      render text: "yysef78qwgdDBZJoN6FEx2oCJrIeCCF6XKByFQR0njQ.y8WTLTOwWWbA4olBERIK4CspJS7ZCK6dcZfOO2kgCP8"
    else
      render text: "Bv58Dk9Pudj82oAyBwScNIKkbJ1nBEVSakWh1UOjW8g.y8WTLTOwWWbA4olBERIK4CspJS7ZCK6dcZfOO2kgCP8"
    end
  end
end
