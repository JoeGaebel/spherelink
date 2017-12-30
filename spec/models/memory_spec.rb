require 'spec_helper'

describe Memory, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe "factory" do
    let(:model) { create(:memory) }

    it "is valid" do
      expect(model).to be_valid
    end
  end
end
