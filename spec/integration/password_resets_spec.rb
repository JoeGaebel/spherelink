require 'spec_helper'

describe 'Password Resetting' do
  before do
    ActionMailer::Base.deliveries.clear
    @user = create(:user)
  end

  it 'renders the correct template' do
    get new_password_reset_path
    assert_template 'password_resets/new'
  end

  describe '#create' do
    def do_request(options = {})
      post password_resets_path, params: { password_reset: options }
    end

    context 'with a valid email' do
      it 'creates the digest attrs and sends an email' do
        do_request(email: @user.email)
        @user.reload
        expect(@user.reset_digest).to be_present
        expect(@user.reset_sent_at).to be_present
        expect(ActionMailer::Base.deliveries.size).to eq(1)

        expect(flash[:info]).to be_present
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with an invalid email' do
      it 'flashes and redirects back' do
        do_request(email: '')
        expect(flash[:danger]).to be_present
        assert_template 'password_resets/new'
      end
    end
  end

  describe '#edit' do
    def do_request(token, options={})
      get edit_password_reset_path(token, options)
    end

    before do
      @user.create_reset_digest
    end

    context 'with a wrong email' do
      it 'redirects to home' do
        do_request(@user.reset_token, email: '')
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with an inactive user' do
      before do
        @user.toggle!(:activated)
      end

      it 'redirects to home' do
        do_request(@user.reset_token, email: @user.email)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with a wrong token' do
      it 'redirects home' do
        do_request('wrong token', email: @user.email)
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with a correct email and token' do
      it 'renders the edit template' do
        do_request(@user.reset_token, email: @user.email)
        assert_template 'password_resets/edit'
        assert_select 'input[name=email][type=hidden][value=?]', @user.email
      end
    end
  end

  describe '#update' do
    def do_request(reset_token, options = {})
      patch password_reset_path(reset_token), params: options
    end

    before do
      @user.create_reset_digest
    end

    context 'with non-matching password confirmation' do
      it 'flashes an error' do
        do_request(@user.reset_token, {
          email: @user.email,
          user: {
            password: 'Unicorn startups',
            password_confirmation: 'are the bessst'
          }
        })

        assert_select 'div#error_explanation'
      end
    end

    context 'with an empty password' do
      it 'flashes an error' do
        # Empty password
        do_request(@user.reset_token, {
          email: @user.email,
          user: {
            password: '',
            password_confirmation: ''
          }
        })

        assert_select 'div#error_explanation'
      end
    end

    context 'with a valid password and password confirmation' do
      let(:password) { 'supersecurepassword42' }
      let(:password_confirmation) { password }

      context 'with an unexpired token' do
        before do
          expect(@user.password_reset_expired?).to be_falsey
        end

        it "resets the user's password" do
          do_request(@user.reset_token, {
            email: @user.email,
            user: {
              password: password,
              password_confirmation: password_confirmation
            }
          })

          expect(is_logged_in?).to be_truthy
          expect(flash[:success]).to be_present
          expect(response).to redirect_to(@user)

          @user.reload
          expect(@user.reset_digest).to be_nil
          expect(@user.authenticated?(:password, password)).to be_truthy
        end
      end

      context 'with an expired token' do
        before do
          @user.update_attribute(:reset_sent_at, 3.hours.ago)
          expect(@user.password_reset_expired?).to be_truthy
        end

        it 'flashes and redirects' do
          do_request(@user.reset_token, {
            email: @user.email,
            user: {
              password: password,
              password_confirmation: password_confirmation
            }
          })

          expect(is_logged_in?).to be_falsey
          expect(flash[:danger]).to be_present
          expect(response).to redirect_to(new_password_reset_url)

          @user.reload
          expect(@user.authenticated?(:password, password)).to be_falsey
        end
      end
    end
  end
end
