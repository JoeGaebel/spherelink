require 'spec_helper'

describe UsersController do
  render_views

  it 'should get new' do
    get :new
    assert_response :success
  end

  describe 'creating users' do
    def do_request(options= {})
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

      expect(response).to redirect_to User.last
      expect(is_logged_in?).to be_truthy
    end

    it 'does not create a User with invalid attributes' do
      get :new

      expect {
        do_request({name:  '', email: 'user@invalid', password: 'foo', password_confirmation: 'bar'})
      }.to change {
        User.count
      }.by(0)

      assert_template 'users/new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end
  end

  describe 'editing users' do
    def do_request(id, options= {})
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
  end
end
