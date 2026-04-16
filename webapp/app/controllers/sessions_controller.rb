class SessionsController < Devise::SessionsController
  def new
    @page_title = "Login"
    super
  end
end
