require "rails_helper"

RSpec.describe "User Create", :type => :request do
  let(:parsed_body) {JSON.parse(response.body).symbolize_keys}

  before :each do
    allow(Mirroring::UserCreate).to receive(:new)
    post api_v1_users_path(user_params)
  end

  describe "With valid params" do
    let(:user_params) {{email: "test1@babar.com"}}

    it "instanciate a user mirroring process" do
      expect(Mirroring::UserCreate).to have_received(:new).with(user_params)
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
        expect(Mirroring::UserCreate).not_to have_received(:new).with(user_params)
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
        expect(Mirroring::UserCreate).not_to have_received(:new).with(user_params)
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
        expect(Mirroring::UserCreate).not_to have_received(:new).with(user_params)
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