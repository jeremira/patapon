require "rails_helper"

describe "External::Hubspot" do

  describe ".create_user" do
    let(:hubspot_create_user) {External::Hubspot.create_user(email: user_email)}
    let(:user_email)  {"babar@test.com"}

    context "with valid params" do
      let(:stubed_response) {instance_double("Hubspot::Contact")}
      before :each do
        expect(Hubspot::Contact).to receive(:create!).with(user_email) do
          stubed_response
        end
      end

      it "return relevant Hubspot::Contact instance" do
        expect(hubspot_create_user).to be stubed_response
      end
    end

    context "with invalid params" do
      before :each do
        expect(Hubspot::Contact).to receive(:create!).with(user_email).and_raise(
          Hubspot::RequestError
        )
      end

      it "return false" do
        expect(hubspot_create_user).to be false
      end
    end

    context "when Hubspot Config are invalid" do
      before :each do
        expect(Hubspot::Contact).to receive(:create!).with(user_email).and_raise(
          Hubspot::ConfigurationError
        )
      end

      it "return false" do
        expect(hubspot_create_user).to be false
      end
    end

    context "when everithing goes wrong" do
      before :each do
        expect(Hubspot::Contact).to receive(:create!).with(user_email).and_raise
      end

      it "return false" do
        expect(hubspot_create_user).to be false
      end
    end
  end
end
