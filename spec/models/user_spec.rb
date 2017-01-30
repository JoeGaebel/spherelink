require 'spec_helper'

describe User do
  describe 'validations' do
    before do
      @user = build(:user)
    end

    it { should have_many(:microposts).dependent(:destroy) }

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

  describe '#authenticated?' do
    before do
      @user = build(:user)
      expect(@user.remember_digest).to eq(nil)
    end

    it 'should return false for a user with nil digest' do
      expect(@user.authenticated?(:remember, '')).to eq(false)
    end
  end

  describe 'following' do
    before do
      @user = create(:user)
      @other_guy = create(:user)
    end

    it 'should follow and unfollow a user' do
      expect(@user).not_to be_following(@other_guy)
      @user.follow(@other_guy)

      expect(@user).to be_following(@other_guy)
      expect(@other_guy.followers).to include(@user)
      @user.unfollow(@other_guy)

      expect(@user).not_to be_following(@other_guy)
    end
  end

  describe 'feed' do
    before do
      @user = create(:user)
      @followed_user = create(:user)
      @not_followed_user = create(:user)

      5.times do
        create(:micropost, user: @user)
        create(:micropost, user: @followed_user)
        create(:micropost, user: @not_followed_user)
      end

      create(:relationship, {
        follower_id: @user.id,
        followed_id: @followed_user.id
      })
    end


    it 'should have the right posts' do
      @followed_user.microposts.each do |post_following|
        expect(@user.feed).to include(post_following)
      end

      @user.microposts.each do |post_self|
        expect(@user.feed).to include(post_self)
      end

      @not_followed_user.microposts.each do |post_unfollowed|
        expect(@user.feed).not_to include(post_unfollowed)
      end
    end
  end
end
