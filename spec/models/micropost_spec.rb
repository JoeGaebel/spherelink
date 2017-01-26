require 'spec_helper'

describe Micropost do
  let(:content) { Faker::Hipster.sentence(3, false, 4) }

  before do
    @user = create(:user)
    @micropost = @user.microposts.build(content: content)
  end

  it 'is valid' do
    expect(@micropost).to be_valid
  end

  it { should belong_to(:user) }

  describe 'validations' do
    it 'needs a user' do
      @micropost.user_id = nil
      expect(@micropost).not_to be_valid
    end

    context 'content' do
      it 'needs to be non-blank' do
        @micropost.content = '   '
        expect(@micropost).not_to be_valid
      end

      it 'enforces a limit of 140' do
        @micropost.content = 'a'*141
        expect(@micropost).not_to be_valid
      end
    end
  end

  describe 'order' do
    let(:later_time) { 3.days.ago }
    let(:earlier_time) { 1.day.ago }

    before do
      expect(later_time).to be < earlier_time

      4.times do |index|
        create(:micropost, {
          user: @user,
          created_at: later_time
        })
      end

        @micropost.update_attribute(:created_at, earlier_time)
        expect(Micropost.all.size).to eq(5)
      end

    it 'should order by most recent first' do
      expect(Micropost.first).to eq(@micropost)
    end
  end
end
