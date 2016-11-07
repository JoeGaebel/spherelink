require 'spec_helper'

describe User do
  describe 'validations' do
    before do
      @user = build(:user)
    end

    describe 'name' do
      it 'should be valid' do
        expect(@user).to be_valid
      end

      it 'should require presence of name' do
        @user.name = " "
        expect(@user).not_to be_valid
      end

      it 'should require presence of email' do
        @user.email = " "
        expect(@user).not_to be_valid
      end

      it 'should have a name that is not too long' do
        @user.name = 'a' * 51
        expect(@user).not_to be_valid
      end
    end

    describe 'emails' do
      it 'should have an email that is not too long' do
        @user.email = 'a' * 244 + '@example.com'
        expect(@user).not_to be_valid
      end

      it 'should accept valid emails' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end

      it 'email validation should reject invalid addresses' do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          @user.email = invalid_address
          expect(@user).to_not be_valid
        end
      end

      it 'checks for email uniqueness' do
        duplicate_user = @user.dup
        duplicate_user.email.upcase!
        @user.save
        expect(duplicate_user).to_not be_valid
      end

      it 'downcases the email on save' do
        @user = create(:user, email: 'SICK@SICK.COM')
        expect(@user.email).to eq('sick@sick.com')
      end
    end

    describe 'passwords' do
      let(:valid_length) { User::VALID_PASSWORD_LENGTH }

      it 'requires a password' do
        expect(@user).to be_valid
        @user.password = nil
        @user.save
        expect(@user).not_to be_valid
      end

      it 'should have a minimum length' do
        @user.password = @user.password_confirmation = 'a' * (valid_length - 1)
        expect(@user).to_not be_valid
      end
    end
  end
end
