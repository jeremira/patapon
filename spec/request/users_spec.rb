require "rails_helper"

RSpec.describe "User Create", :type => :request do
  let(:parsed_body) {JSON.parse(response.body).symbolize_keys}

  describe "User mirroring" do
    before :each do
      Sidekiq::Testing.inline!
      post api_v1_users_path(user_params)
    end

    let(:user) {User.find_by(email: "babar@ŧest.com")}

    context "with only email" do
      let(:user_params) {{email: "babar@test.com"}}

      it "create an User" do
        expect(User.count).to eq 1
      end
      it "setup correct email" do
        expect(user).to be_an User
      end
      it "do not setup a note" do
        expect(user.note).to be nil
      end
    end
  end

  describe "Background worker" do
    before :each do
      allow(UserWorker).to receive(:perform_async)
      post api_v1_users_path(user_params)
    end

    describe "With valid params" do
      let(:user_params) {{email: "test1@babar.com"}}

      it "instanciate a user mirroring process" do
        expect(UserWorker).to have_received(:perform_async).with(user_params)
      end
      it "render 200" do
        expect(response.status).to eq 200
      end
      it "has a no error message" do
        expect(parsed_body[:error]).to be nil
      end
    end

    describe "with invalid params" do

      context "with no email" do
        let(:user_params) {nil}

        it "do not instanciate a user mirroring process" do
          expect(UserWorker).not_to have_received(:perform_async)
        end
        it "render 422" do
          expect(response.status).to eq 422
        end
        it "has a valid error message" do
          expect(parsed_body[:error]).to eq "An email is required."
        end
      end

      context "with a blank email" do
        let(:user_params) {{email: ""}}

        it "do not instanciate a user mirroring process" do
          expect(UserWorker).not_to have_received(:perform_async)
        end
        it "render 422" do
          expect(response.status).to eq 422
        end
        it "has a valid error message" do
          expect(parsed_body[:error]).to eq "An email is required."
        end
      end

      context "with a nil email" do
        let(:user_params) {{email: nil}}

        it "do not instanciate a user mirroring process" do
          expect(UserWorker).not_to have_received(:perform_async)
        end
        it "render 422" do
          expect(response.status).to eq 422
        end
        it "has a valid error message" do
          expect(parsed_body[:error]).to eq "An email is required."
        end
      end
    end
  end
end
