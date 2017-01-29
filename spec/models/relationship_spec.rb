require 'spec_helper'

describe Relationship do
  before do
    @user = create(:user)
    @other_user = create(:user)

    @relationship = create(:relationship, {
      follower_id: @user.id,
      followed_id: @other_user.id
    })
  end

  it 'should be valid' do
    expect(@relationship).to be_valid
  end

  it 'requires a follower_id' do
    @relationship.follower_id = nil
    expect(@relationship).not_to be_valid
  end

  it 'should require a followed_id' do
    @relationship.followed_id = nil
    expect(@relationship).not_to be_valid
  end
end
