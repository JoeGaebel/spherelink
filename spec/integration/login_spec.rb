describe 'user login' do
  context 'with valid information followed by a logout' do
    before do
      @user = create(:user, password: 'password')
    end

    it 'manages the session and links' do
      get login_path
      post login_path, params: { session: { email: @user.email,
        password: 'password' } }
      assert is_logged_in?
      assert_redirected_to @user
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(@user)
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
end
