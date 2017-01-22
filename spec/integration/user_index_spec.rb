require 'spec_helper'

describe 'user index' do
  before do
    35.times do |n|
      create(:user, {
        name: "example #{n+1}",
        email: "example#{n+1}@example.com"
      })
    end

    @user = create(:user)
  end

  it 'paginates' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  describe 'delete links' do
    context 'as an admin' do
      before do
        @user = create(:user, admin: true)
        @other_user = create(:user)
      end

      it 'includes delete links' do
        log_in_as(@user)
        get users_path

        User.paginate(page: 1).each do |user|
          assert_select 'a[href=?]', user_path(user), text: user.name
          unless user == @user
            assert_select 'a[href=?]', user_path(user), text: 'delete'
          end
        end

        expect {
          delete user_path(@other_user)
        }.to change { User.count }.by(-1)
      end
    end

    context 'as a non-admin' do
      before do
        @user = create(:user, admin: false)
      end

      it 'does not show delete links' do
        log_in_as(@user)
        get users_path
        assert_select 'a', text: 'delete', count: 0
      end
    end
  end
end
