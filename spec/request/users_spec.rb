require "rails_helper"

RSpec.describe "User Create", :type => :request do
  let(:parsed_body) {JSON.parse(response.body).symbolize_keys}

  describe "User Creation" do
    before :each do
      Sidekiq::Testing.inline!
    end

    let(:user) {User.find_by(email: "babar@test.com")}

    context "with no params" do
      let(:user_params) {nil}

      before :each do
        post api_v1_users_path(user_params)
        UserWorker.drain
      end

      it "do not create an User" do
        expect(User.count).to eq 0
      end
      it "render 422" do
        expect(response.status).to eq 422
      end
      it "has a valid error message" do
        expect(parsed_body[:error]).to eq "An email is required."
      end
    end

    context "with empty email" do
      let(:user_params) {{email: "  "}}

      before :each do
        post api_v1_users_path(user_params)
        UserWorker.drain
      end

      it "do not create an User" do
        expect(User.count).to eq 0
      end
      it "render 422" do
        expect(response.status).to eq 422
      end
      it "has a valid error message" do
        expect(parsed_body[:error]).to eq "An email is required."
      end
    end

    context "with nil email" do
      let(:user_params) {{email: nil}}

      before :each do
        post api_v1_users_path(user_params)
        UserWorker.drain
      end

      it "do not create an User" do
        expect(User.count).to eq 0
      end
      it "render 422" do
        expect(response.status).to eq 422
      end
      it "has a valid error message" do
        expect(parsed_body[:error]).to eq "An email is required."
      end
    end

    context "with only email" do
      let(:user_params) {{email: "babar@test.com"}}

      before :each do
        expect(Hubspot::Contact).to receive(:create!).once.with("babar@test.com")
        post api_v1_users_path(user_params)
        UserWorker.drain
      end

      it "create an User" do
        expect(User.count).to eq 1
      end
      it "setup correct email" do
        expect(user).to be_an User
      end
      it "do not setup a note" do
        expect(user.note).to be nil
      end
      it "render 200" do
        expect(response.status).to eq 200
      end
      it "has a no error message" do
        expect(parsed_body[:error]).to be nil
      end
    end

    context "with email & note" do
      let(:user_params) {{email: "babar@test.com", note: "Worker must seize means of production."}}

      before :each do
        expect(Hubspot::Contact).to receive(:create!).once.with("babar@test.com") do
          instance_double("Hubspot::Contact", vid: 666)
        end
        expect(Hubspot::EngagementNote).to receive(:create!).once.with(666, "Worker must seize means of production.")
        post api_v1_users_path(user_params)
        UserWorker.drain
      end

      it "create an User" do
        expect(User.count).to eq 1
      end
      it "setup correct email" do
        expect(user).to be_an User
      end
      it "do setup correct note" do
        expect(user.note).to eq "Worker must seize means of production."
      end
      it "render 200" do
        expect(response.status).to eq 200
      end
      it "has a no error message" do
        expect(parsed_body[:error]).to be nil
      end
    end
  end

  describe "Background worker" do
    before :each do
      allow(UserWorker).to receive(:perform_async)
      post api_v1_users_path(user_params)
    end

    describe "With valid params" do

      context "only email" do
        let(:user_params) {{email: "test1@babar.com"}}

        it "instanciate a user mirroring process" do
          expect(UserWorker).to have_received(:perform_async).with({email: "test1@babar.com", note: nil})
        end
      end

      context "email & note" do
        let(:user_params) {{email: "test1@babar.com", note: "babouche et espadrille"}}

        it "instanciate a user mirroring process" do
          expect(UserWorker).to have_received(:perform_async).with(user_params)
        end
      end
    end

    describe "with invalid params" do

      let(:user_params) {{email: nil}}

      it "do not instanciate a user mirroring process" do
        expect(UserWorker).not_to have_received(:perform_async)
      end
    end
  end
end
