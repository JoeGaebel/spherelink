module ValidUserRequestHelper
  def request_log_in(user)
    page.driver.post user_session_path, :user => { :email => user.email, :password => user.password }
  end
end