require 'spec_helper'

describe 'Microposts' do
  before do
    @user = create(:user)
  end

  describe 'sidebar view' do
    let(:post_number) { 2 }

    before do
      post_number.times do
        create(:micropost, user: @user)
      end

      @other_user = create(:user)
    end

    it 'displays and updates the count' do
      log_in_as(@user)
      get root_path
      assert_match "#{post_number} microposts", response.body

      log_in_as(@other_user)
      get root_path
      expect(response.body).to include('0 microposts')

      create(:micropost, user: @other_user)
      get root_path
      expect(response.body).to include('1 micropost')
    end
  end

  describe 'creating a micropost' do
    def do_request(content)
      post microposts_path, params: { micropost: { content: content } }
    end

    context 'with an invalid submission' do
      let(:invalid_content) { nil }

      it 'redirects and shows an error' do
        log_in_as(@user)
        get root_path
        expect { do_request(invalid_content) }.not_to change { Micropost.count }
        assert_select 'div#error_explanation'
      end
    end

    context 'with sufficient posts' do
      before do
        32.times do
          create(:micropost, user: @user)
        end
      end

      it 'paginates' do
        log_in_as(@user)
        get root_path
        assert_select 'div.pagination'
      end
    end

    context 'with a valid submission' do
      let(:valid_content) { 'Non-alcoholic beers!? Wow!' }

      it 'posts the micropost' do
        log_in_as(@user)
        get root_path
        expect { do_request(valid_content) }.to change { Micropost.count }.by(1)
        expect(response).to redirect_to(root_url)
        follow_redirect!
        expect(response.body).to include valid_content
      end
    end
  end

  describe 'destroying a micropost' do
    before do
      @micropost = create(:micropost, user: @user)
    end

    def do_request(micropost)
      delete micropost_path(micropost)
    end

    it 'deletes and removes the links' do
      log_in_as(@user)
      get user_path(@user)
      assert_select 'a', text: 'delete'
      expect{ do_request(@micropost) }.to change {
        Micropost.count
      }.by(-1)

      get user_path(@user)
      assert_select 'a', text: 'delete', count: 0
    end
  end
end
