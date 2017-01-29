require 'spec_helper'

describe MicropostsController, type: :request do
  before do
    @user = create(:user)
    @micropost = create(:micropost, user: @user)
  end

  describe '#create' do
    def do_request(options = {})
      post microposts_path, params: { micropost: options }
    end

    it 'should redirect when not logged in' do
      expect { do_request(content: 'totally worthy of a status') }.
        not_to change { Micropost.count }
      expect(response).to redirect_to(login_url)
    end
  end

  describe '#destroy' do
    def do_request(micropost)
      delete micropost_path(micropost)
    end

    it 'should redirect when not logged in' do
      expect { do_request(@micropost) }.
        not_to change { Micropost.count }
      expect(response).to redirect_to(login_url)
    end

    context 'when logged in with the correct user' do
      before do
        log_in_as(@user)
      end

      it 'deletes the micropost' do
        expect{ do_request(@micropost) }.to change {
          Micropost.count
        }.by(-1)
      end
    end

    context 'when logged in with a different user' do
      before do
        @other_guy = create(:user)
        log_in_as(@other_guy)
      end

      it 'redirects home' do
        expect{ do_request(@micropost) }.not_to change { Micropost.count }
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
