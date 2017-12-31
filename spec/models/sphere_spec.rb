require 'spec_helper'

describe Sphere, type: :model do
  it { is_expected.to validate_presence_of :caption }

  describe "factory" do
    let!(:model) { create(:sphere) }

    it "is valid" do
      expect(model).to be_valid
    end

    it "has a guid" do
      expect(model.guid).to be_present
    end
  end
end
