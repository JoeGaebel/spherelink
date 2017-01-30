require 'spec_helper'

describe 'Following' do
  before do
    @user = create(:user)
    @other_user = create(:user)

    log_in_as(@user)
  end

  context 'when following other users' do
    before do
      5.times { @user.follow(create(:user)) }
    end

    it 'displays the followed users' do
      get following_user_path(@user)
      expect(@user.following).to be_present
      expect(response.body).to include(@user.following.count.to_s)

      @user.following.each do |user|
        assert_select 'a[href=?]', user_path(user)
      end
    end
  end

  context 'when other users following' do
    before do
      5.times { create(:user).follow(@user) }
    end

    it 'displays the followers' do
      get followers_user_path(@user)
      expect(@user.followers).to be_present
      expect(response.body).to include(@user.followers.count.to_s)

      @user.followers.each do |user|
        assert_select 'a[href=?]', user_path(user)
      end
    end
  end

  describe 'following and unfollowing' do
    it 'should follow a user the standard way' do
      expect {
        post relationships_path,
          params: { followed_id: @other_user.id }
      }.to change { @user.following.count }.by( 1)
    end

    it 'should follow a user with Ajax' do
      expect {
        post relationships_path,
          xhr: true,
          params: { followed_id: @other_user.id }
      }.to change { @user.following.count }.by(1)
    end

    it 'should unfollow a user the standard way' do
      @user.follow(@other_user)
      relationship = @user.active_relationships.find_by(followed_id: @other_user.id)

      expect { delete relationship_path(relationship) }.
        to change { @user.following.count }.by(-1)
    end

    it 'should unfollow a user with Ajax' do
      @user.follow(@other_user)
      relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
      expect { delete relationship_path(relationship), xhr: true }.
        to change { @user.following.count }.by(-1)
      end
  end

  describe 'the home page feed' do
    before do
      5.times do
        create(:micropost, user: @other_user)
      end

      create(:relationship, {
        follower_id: @user.id,
        followed_id: @other_user.id
      })
    end

    it 'feeds well' do
      get root_path
      @user.feed.paginate(page: 1).each do |micropost|
        expect(response.body).to include(CGI.escapeHTML(micropost.content))
      end
    end
  end
end
