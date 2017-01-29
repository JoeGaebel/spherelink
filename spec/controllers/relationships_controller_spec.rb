require 'spec_helper'

describe RelationshipsController, type: :request do
  before do
    @user = create(:user)
  end

  describe '#create' do
    def do_request
      post relationships_path
    end

    it 'create should require logged-in user' do
      expect { do_request }.not_to change { Relationship.count }
      expect(response).to redirect_to(login_url)
    end
  end

  describe '#destroy' do
    before do
      @other_user = create(:user)
      @relationship = create(:relationship, {
        follower_id: @user.id,
        followed_id: @other_user.id
      })
    end

    def do_request(relationship)
      delete relationship_path(relationship)
    end

    it 'destroy should require logged-in user' do
      expect { do_request(@relationship) }.
        not_to change { Relationship.count }
      expect(response).to redirect_to(login_url)
    end
  end
end
