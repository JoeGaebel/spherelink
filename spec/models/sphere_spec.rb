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

  describe "validations" do
    describe "file size" do
      let(:sphere) { create(:sphere) }

      before do
        expect(sphere).to be_valid
      end

      context "with a file greater than 15MB" do
        before do
          allow(sphere.panorama.file).to receive(:size).and_return(16.megabytes)
        end

        it "is invalid" do
          expect(sphere).not_to be_valid
          expect(sphere.errors.full_messages).to include /file size must be less than or equal to 15 MB/
        end
      end

      context "with a file greater than 15MB" do
        before do
          expect(sphere.panorama.file.size).to be < 15.megabytes
        end

        it "is valid" do
          expect(sphere).to be_valid
        end
      end
    end

    describe "filetype" do
      context "when the file is an exe" do
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'ohno.exe')) }
        let(:sphere) { build(:sphere, panorama: file) }

        it "does not allow upload" do
          expect(sphere).not_to be_valid
        end
      end
    end
  end
end
