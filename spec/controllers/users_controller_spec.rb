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
end
