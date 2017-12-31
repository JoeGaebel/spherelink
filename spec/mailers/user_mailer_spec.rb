require 'spec_helper'

describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe 'account_activation' do
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(['noreply@spherelink.io'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end

  describe 'password_reset' do
    before do
      user.reset_token = User.new_token
    end

    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(['noreply@spherelink.io'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))

    end
  end
end
