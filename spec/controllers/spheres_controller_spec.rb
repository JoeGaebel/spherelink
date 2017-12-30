require 'spec_helper'

describe SpheresController, type: :controller do
  let(:user) { create(:user) }

  describe "#create" do
    let(:fake_file) { fixture_file_upload('rails.png', 'image/png') }
    let(:caption) { "Cool!" }

    let(:valid_params) do
      {
        memory_id: memory.id,
        sphere: {
            caption: caption,
            panorama: fake_file
        }
      }
    end

    def do_request(params)
      post :create, params: params
    end

    context "when the memory belongs to the current user" do
      let(:memory) { create(:memory, user: user) }

      before do
        expect(memory.user_id).to eq(user.id)
      end

      context "when the sphere is valid" do
        let(:params) { valid_params }
        let(:last_created_sphere) { Sphere.last }
        let(:fake_guid) { "hexadecimal! Rhombus!" }

        before do
          allow(SecureRandom).to receive(:hex).and_return(fake_guid)
        end

        it "sets the caption, panorama, and guid" do
          log_in(user)
          do_request(params)

          expect(last_created_sphere.guid).to eq(fake_guid)
          expect(last_created_sphere.panorama.url).to be_present
          expect(last_created_sphere.caption).to eq(caption)
        end

        it "returns the guid, and processing status" do
          log_in(user)
          do_request(params)

          expect(response).to have_http_status(:processing)
          expect(response.body).to eq(fake_guid)
        end

        describe "processing status" do
          before do
            Sphere.destroy_all
          end

          context "during initial create" do
            before do
              # Below is a janky way of stubbing out the callback
              # # Unfortunately this was the only way that worked.
              SphereUploader._after_callbacks[:store].delete(:update_processing_status)
            end

            after do
              SphereUploader._after_callbacks[:store] << :update_processing_status
            end

            it "sets the processing flag to true" do
              log_in(user)
              do_request(params)

              expect(last_created_sphere).to be_processing
            end
          end

          context "after processing" do
            before do
              # :'(
              expect(SphereUploader._after_callbacks[:store]).to include(:update_processing_status)
            end

            it "sets the processing flag to false" do
              log_in(user)
              do_request(params)

              expect(last_created_sphere).not_to be_processing
            end
          end
        end
      end

      context "when the required params are missing" do
        let(:missing_params) { valid_params.except(:sphere) }
        let(:error_hash) do
          { errors:[{ sphere: ["parameter is required"] }] }.to_json
        end

        it "returns the errors and unprocessable_entity status" do
          log_in(user)
          do_request(missing_params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(error_hash)
        end
      end

      context "when the params are invalid" do
        let(:invalid_params) do
          valid_params.tap do |h|
            h[:sphere][:caption] = nil
          end
        end

        let(:error_hash) { { caption: ["can't be blank"] }.to_json }

        it "returns the errors and unprocessable_entity status" do
          log_in(user)
          do_request(invalid_params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(error_hash)
        end
      end
    end

    context "when the memory does not belong to the current user" do
      let(:other_user) { create(:user) }
      let(:memory) { create(:memory, user: other_user) }

      before do
        expect(memory.user_id).not_to eq(user)
      end

      it "returns not found status" do
        log_in(user)
        do_request(valid_params)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#show" do
    def do_request
      get :show, params: { id: guid }
    end

    context "when the sphere does not exist" do
      let(:guid) { "definitely does not exist" }

      before do
        expect(Sphere.where(guid: guid)).not_to be_exists
      end

      it "returns not found" do
        log_in(user)
        do_request
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the sphere is another users" do
      let(:other_user) { create(:user) }
      let(:memory) { create(:memory, user: other_user) }
      let(:sphere) { memory.spheres.first }
      let(:guid) { "some unique id" }

      before do
        expect(memory.user_id).to eq(other_user.id)
        sphere.update_attribute(:guid, guid)
      end

      it "returns not found" do
        log_in(user)
        do_request
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the sphere is the current users" do
      let(:user) { create(:user) }
      let(:memory) { create(:memory, user: user) }
      let(:sphere) { memory.spheres.first }
      let(:guid) { "some other unique id" }

      before do
        expect(memory.user_id).to eq(user.id)
        sphere.update_attribute(:guid, guid)
      end

      context "when the sphere is being processed" do
        before do
          sphere.update_attribute(:processing_bits, Sphere::MAX_PROCESSING_BIT)
        end

        it "returns the guid and processing status" do
          log_in(user)
          do_request
          expect(response).to have_http_status(:processing)
          expect(response.body).to eq(guid)
        end
      end

      context "when the sphere has finished processing" do
        let(:json_data) { sphere.to_builder.target! }

        before do
          expect(sphere).not_to be_processing
        end

        it "returns json and created status" do
          log_in(user)
          do_request

          expect(response).to have_http_status(:created)
          expect(response.body).to eq(json_data)
        end
      end
    end
  end
end
