require "rails_helper"

describe "Mirroring::User::Create" do
  let(:user_creator) {Mirroring::User::Create.new(user_params)}
  let(:user_params)  {{email: "babar@test.com"}}

  describe "#Initialize" do

    context "with no params" do
      let(:user_creator) {Mirroring::User::Create.new()}

      it "expose user" do
        expect(user_creator.internal_user).to be_an User
      end
      it "do not persist user" do
        expect(user_creator.internal_user.persisted?).to be false
      end
      it "setup user email to nil" do
        expect(user_creator.internal_user.email).to be nil
      end
    end

    context "with email params" do

      it "expose user" do
        expect(user_creator.internal_user).to be_an User
      end
      it "do not persist user" do
        expect(user_creator.internal_user.persisted?).to be false
      end
      it "setup user email to correct value" do
        expect(user_creator.internal_user.email).to eq "babar@test.com"
      end
    end
  end

  describe "#supported_mirrors" do
    it "returns an Array" do
      expect(user_creator.supported_mirrors).to be_an Array
    end
    it "return all external services supported" do
      expect(user_creator.supported_mirrors).to eq([External::Hubspot])
    end
  end

  describe "#mirror_and_save_user" do
    let(:on_try_fonction) {user_creator.mirror_and_save_user}
    #
    # Stub class for external services
    #
    class self::Babar
      def self.create_user(email:) ; end
    end

    before :each do
      allow(self.class::Babar).to receive(:create_user) {stubbed_external_answer}
      allow(user_creator).to receive(:supported_mirrors) {[self.class::Babar]}
    end

    context "for an invalid internal user" do
      let(:stubbed_external_answer) {nil}
      let(:user_params) {{email: nil}}

      it "do not save internal user" do
        expect{on_try_fonction}.not_to change(User, :count)
      end
      it "do not mirror User in Babar services" do
        expect(self.class::Babar).not_to receive(:create_user)
        on_try_fonction
      end
      it "return nil" do
        expect(on_try_fonction).to be nil
      end
    end

    context "for a valid user" do
      let(:user_params) {{email: "babar@test.com"}}

      context "and a valid external call" do
        let(:stubbed_external_answer) {true}

        it "do save internal user" do
          expect{on_try_fonction}.to change(::User, :count).by 1
        end
        it "do mirror User in Babar services" do
          expect(self.class::Babar).to receive(:create_user).with(email: "babar@test.com")
          on_try_fonction
        end
        it "return User instance" do
          expect(on_try_fonction).to be_an User
        end
        it "save user instance" do
          expect(on_try_fonction.persisted?).to be true
        end
      end

      context "but an invalid external call" do
        let(:stubbed_external_answer) {false}

        it "do not save internal user" do
          expect{on_try_fonction}.not_to change(User, :count)
        end
        it "do mirror User in Babar services" do
          expect(self.class::Babar).to receive(:create_user).with(email: "babar@test.com")
          on_try_fonction
        end
        it "return nil" do
          expect(on_try_fonction).to be false
        end
      end
    end
  end
end
