require 'spec_helper'

describe Memory, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe "factory" do
    let(:model) { create(:memory) }

    it "is valid" do
      expect(model).to be_valid
    end
  end

  describe "default scope" do
    let(:user) { create(:user) }
    let(:sorted_order) { user.memories.order("created_at desc").map(&:id) }
    let(:actual_order) { user.memories.map(&:id) }

    before do
      5.times do |i|
        m = create(:memory, user: user)
        m.update_attribute(:created_at, (5-i).days.ago)
      end
    end

    it "sorts based on created at descending" do
      expect(actual_order).to eq(sorted_order)
    end
  end
end
