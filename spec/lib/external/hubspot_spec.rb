require "rails_helper"

describe "External::Hubspot" do

  describe ".add_note" do
    let(:hubspot_add_note) {External::Hubspot.add_note(contact_id: contact_id, note: note)}
    let(:stubed_response) {instance_double("Hubspot::EngagementNote")}

    context "with valid id" do
      let(:contact_id) {666}

      context "and a note content" do
        let(:note) {"babar en espadrille"}

        before :each do
          expect(Hubspot::EngagementNote).to receive(:create!).with(666, note) do
            stubed_response
          end
        end

        it "return Engament Note" do
          expect(hubspot_add_note).to eq stubed_response
        end
      end

      context "and no note content" do
        let(:note) {""}

        it "return false" do
          expect(hubspot_add_note).to be false
        end
      end
    end

    context "with invalid id" do
      let(:contact_id) {666}

      context "and a note content" do
        let(:note) {"babar en espadrille"}

        before :each do
          expect(Hubspot::EngagementNote).to receive(:create!).with(contact_id, note).and_raise(
            Hubspot::RequestError.new(double("response", body: "body"))
          )
        end

        it "return false" do
          expect(hubspot_add_note).to be false
        end
      end

      context "and no note content" do
        let(:note) {""}

        it "return false" do
          expect(hubspot_add_note).to be false
        end
      end
    end

    context "with no contact id" do
      let(:contact_id) {nil}

      context "and a note content" do
        let(:note) {"babar en espadrille"}

        it "return false" do
          expect(hubspot_add_note).to be false
        end
      end

      context "and no note content" do
        let(:note) {""}

        it "return false" do
          expect(hubspot_add_note).to be false
        end
      end
    end
  end

  describe ".create_user" do
    let(:hubspot_create_user) {External::Hubspot.create_user(email: user_email, note: note)}
    let(:note) {nil}
    let(:user_email)  {"babar@test.com"}

    context "with valid params" do
      let(:stubed_response) {instance_double("Hubspot::Contact", vid: 123)}

      context "with no notes" do
        let(:note) {nil}

        before :each do
          expect(Hubspot::Contact).to receive(:create!).with(user_email) do
            stubed_response
          end
          expect(External::Hubspot).not_to receive(:add_note)
        end

        it "return relevant Hubspot::Contact instance" do
          expect(hubspot_create_user).to be stubed_response
        end
      end

      context "with some notes" do
        let(:note) {"tikatikadi ohé ohé"}

        before :each do
          expect(Hubspot::Contact).to receive(:create!).with(user_email) do
            stubed_response
          end
          expect(External::Hubspot).to receive(:add_note).with(contact_id: 123, note: note)
        end

        it "return relevant Hubspot::Contact instance" do
          expect(hubspot_create_user).to be stubed_response
        end
      end
    end

    context "with invalid params" do
      before :each do
        expect(Hubspot::Contact).to receive(:create!).with(user_email).and_raise(
          Hubspot::RequestError.new(double("response", body: "body"))
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
  end
end
