require "rails_helper"

describe "Mirroring::User::Create" do
  let(:user_creator) {Mirroring::User::Create.new(user_params)}

  describe "#Initialize" do

    context "with no params" do
      let(:user_creator) {Mirroring::User::Create.new()}

      it "expose email" do
        expect(user_creator.email).to be nil
      end
    end

    context "with email params" do
      let(:user_params) {{email: "babar@test.com"}}
      
      it "expose email" do
        expect(user_creator.email).to eq "babar@test.com"
      end
    end
  end
end
