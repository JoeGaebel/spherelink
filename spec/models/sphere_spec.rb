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

    it "starts out as not processing" do
      expect(model).to_not be_processing
    end

    describe "processing_bits" do
      it "responds to main_processing" do
        expect(model).to respond_to(:main_processing?)
      end

      it "responds to thumb_processing" do
        expect(model).to respond_to(:thumb_processing?)
      end
    end
  end
end
