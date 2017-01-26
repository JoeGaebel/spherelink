describe 'User Profile' do
  before do
    @user = create(:user)

    35.times do |index|
      @user.microposts.create!({
        content: hipster_ipsum,
        created_at: index.days.ago
      })
    end
  end

  describe 'displaying a profile' do
    it 'displays correctly' do
      get user_path(@user)
      assert_template 'users/show'
      assert_select 'title', @user.name + ' | Social Microloan'
      assert_select 'h1', text: @user.name
      assert_select 'h1>img.gravatar'
      assert_match @user.microposts.count.to_s, response.body
      assert_select 'div.pagination', 1
      @user.microposts.paginate(page: 1).each do |micropost|
        assert_select "li#micropost-#{micropost.id}"
      end
    end
  end
end
