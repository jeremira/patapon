require 'rails_helper'
RSpec.describe UserWorker, type: :worker do

  it "instantiate a mirroring creation process" do
    expect(Mirroring::User::Create).to receive(:new).with(email: "test@babar.com") do
      instance_double("Mirroring::User::Create", mirror_and_save_user: nil)
    end
    UserWorker.new.perform(email: "test@babar.com")
  end
end
