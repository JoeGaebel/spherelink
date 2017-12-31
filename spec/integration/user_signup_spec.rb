require 'spec_helper'

describe 'user signup' do
  before do
    ActionMailer::Base.deliveries.clear
  end

  def do_request(params)
    post users_path, params: { user: params }
  end

  context 'with invalid information' do
    let(:invalid_params) {{
      name:  '',
      email: 'user@invalid',
      password: 'foo',
      password_confirmation: 'bar'
    }}

    it 'invalid signup information' do
      expect { do_request(invalid_params) }.not_to change { User.count }
      assert_template 'users/new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end
  end

  context 'with valid information' do
    def do_activate_request(id, options)
      get edit_account_activation_path(id, options)
    end

    let(:valid_params) {{
      name:  'Example User',
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    }}

    it 'sends an activation email' do
      expect { do_request(valid_params) }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'creates a user who is not activated' do
      expect { do_request(valid_params) }.to change { User.count }.by(1)
      expect(User.last).to_not be_activated
    end

    it 'prevents logins until activated' do
      do_request(valid_params)
      expect(response).to redirect_to(root_url)
      expect(flash[:info]).to be_present

      user = assigns(:user)
      expect(user).not_to be_activated
      expect(user.activation_token).to be_present

      log_in_as(user)
      expect(is_logged_in?).to eq(false)

      do_activate_request("invalid token", email: user.email)
      expect(is_logged_in?).to eq(false)


      do_activate_request(user.activation_token, email: 'wrong')
      expect(is_logged_in?).to eq(false)

      do_activate_request(user.activation_token, email: user.email)
      expect(user.reload).to be_activated

      follow_redirect!
      assert_template 'memories/index'
      expect(is_logged_in?).to eq(true)
    end
  end
end
