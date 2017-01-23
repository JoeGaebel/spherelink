require 'spec_helper'

describe UsersController do
  render_views

  it 'should get #new' do
    get :new
    assert_response :success
  end

  describe '#create' do
    def do_request(options = {})
      post :create, params: { user: options }
    end

    it 'creates a User with valid attributes' do
      get :new

      expect {
        do_request({
          name:  'Testing',
          email: 'test@test.com',
          password: 'testingtesting',
          password_confirmation: 'testingtesting'
        })
      }.to change {
        User.count
      }.by(1)

      expect(response).to redirect_to root_url
      expect(is_logged_in?).to be_falsey
    end

    it 'does not create a User with invalid attributes' do
      get :new

      expect {
        do_request({
          name:  '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        })
      }.to change {
        User.count
      }.by(0)

      assert_template 'users/new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end

    it 'does not allow admin to be set' do
      get :new

      hacker_name = 'I can haz admin?'

      do_request({
        name:  hacker_name,
        email: 'admin@example.com',
        password: 'password',
        password_confirmation: 'password',
        admin: true
      })

      created_user = User.last
      expect(created_user.name).to eq(hacker_name)
      expect(created_user).not_to be_admin
    end
  end

  describe '#edit' do
    def do_request(id, options = {})
      patch :update, params: { id: id, user: options }
    end

    def get_edit(user_id)
      get :edit, params: { id: user_id }
    end

    before do
      @user = create(:user)
    end

    context 'with an unsuccessful edit' do
      it 'redirects' do
        log_in(@user)
        get_edit(@user.id)

        assert_template 'users/edit'

        do_request(@user.id, { name:  '',
          email: 'foo@invalid',
          password:              'foo',
          password_confirmation: 'bar'
        })

        assert_template 'users/edit'
      end
    end

    context 'with a successful edit' do
      it 'saves the attributes and flashes' do
        log_in(@user)
        get_edit(@user.id)
        assert_template 'users/edit'
        name  = 'Foo Bar'
        email = 'foo@bar.com'

        do_request(@user.id, { name:  name,
          email: email,
          password:              '',
          password_confirmation: ''
        })

        expect(flash[:success]).to be_present
        expect(response).to redirect_to(@user)

        @user.reload

        expect(@user.name).to eq(name)
        expect(@user.email).to eq(email)
      end
    end

    context 'with a wrong user' do
      before do
        @other_user = create(:user, name: 'Josie', email: 'josie@example.com')
      end

      it 'edit redirects to home' do
        log_in(@other_user)
        get_edit(@user.id)
        expect(flash).to_not be_present
        expect(response).to redirect_to(root_url)
      end

      it 'update redirects to home' do
        log_in(@other_user)
        do_request(@user.id, { name: 'Definitely not Bob' })
        expect(flash).to_not be_present
        expect(response).to redirect_to(root_url)
      end
    end

    it 'does not allow admin to be set' do
      log_in(@user)
      do_request(@user.id, {
        admin: true
      })

      expect(flash[:success]).to be_present
      expect(response).to redirect_to(@user)

      @user.reload
      expect(@user).not_to be_admin
    end
  end

  describe '#index' do
    def do_request
      get :index
    end

    context 'when not logged in' do
      before do
        expect(is_logged_in?).to eq(false)
      end

      it 'redirects to login' do
        do_request
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe '#destroy' do
    before do
      @user = create(:user, admin: true)
      @other_user = create(:user, {
        name: 'Billy Bob',
        email: 'jimbob@example.com'
      })
    end

    def do_request(user)
      delete :destroy, params: { id: user.id }
    end

    context 'when not logged in' do
      before do
        expect(is_logged_in?).to eq(false)
      end

      it 'should redirect' do
        expect { do_request(@user) }.not_to change { User.count }
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when logged in as a non admin' do
      before do
        expect(@other_user).not_to be_admin
        log_in(@other_user)
      end

      it 'should redirect to root path' do
        expect { do_request(@user) }.not_to change { User.count }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when logged in as an admin' do
      before do
        log_in(@user)
      end

      it 'deletes and flashes' do
        expect { do_request(@other_user) }.to change {
          User.count
        }.by(-1)

        expect(flash[:success]).to be_present
        expect(response).to redirect_to(users_url)
      end
    end
  end

  describe '#show' do
    before do
      @user = create(:user)
    end

    def do_request(user)
      get :show, params: { id: user.id }
    end

    context 'when the user is not activated' do
      before do
        @other_guy = create(:user, activated: false)
      end

      it 'redirects' do
        log_in(@user)
        do_request(@other_guy)
        expect(response).to redirect_to root_url
      end
    end

    context 'when the user is activated' do
      before do
        @other_guy = create(:user)
      end

      it 'shows the user page' do
        log_in(@user)
        do_request(@other_guy)
        assert_select 'section.user_info'
      end
    end
  end
end
