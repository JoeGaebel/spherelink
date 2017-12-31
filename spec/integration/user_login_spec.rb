describe 'user login' do
  def do_request(session)
    post login_path, params: { session: session }
  end

  context 'with valid information followed by a logout' do
    before do
      @user = create(:user, password: 'password')

      2.times do
        create(:memory)
      end
    end

    it 'manages the session and links' do
      get login_path
      do_request(email: @user.email, password: 'password')
      assert is_logged_in?
      assert_redirected_to memories_path
      follow_redirect!
      assert_template 'memories/index'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      delete logout_path
      assert !is_logged_in?
      assert_redirected_to root_url
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", user_path(@user), count: 0
    end
  end

  describe 'cookies' do
    before do
      @user = create(:user)
    end

    context 'login with remembering' do
      it 'sets the cookie' do
        log_in_as(@user, remember_me: '1')
        expect(cookies['remember_token']).to be_present
        expect(cookies['remember_token']).to eq(assigns(:user).remember_token)
      end
    end

    context 'login without remembering' do
      it 'clears the cookie' do
        log_in_as(@user, remember_me: '1')
        log_in_as(@user, remember_me: '0')
        expect(cookies['remember_token']).to_not be_present
      end
    end
  end

  describe 'friendly forwarding' do
    before do
      @user = create(:user)
    end

    it 'redirects back to the correct page after auth' do
      get edit_user_path(@user.id)
      expect(response).to redirect_to(login_url)

      log_in_as(@user)
      expect(response).to redirect_to(edit_user_url(@user))
    end
  end

  context 'with an unactivated user' do
    before do
      @user = create(:user, activated: false)
    end

    it 'flashes that you are not activated' do
      do_request(email: @user.email, password: 'password')
      expect(is_logged_in?).to be_falsey
      expect(response).to redirect_to(root_url)
      expect(flash[:warning]).to be_present
    end
  end
end
