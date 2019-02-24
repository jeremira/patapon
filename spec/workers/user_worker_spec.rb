require 'rails_helper'
RSpec.describe UserWorker, type: :worker do

  it "properly enqueue a job" do
    expect {
      UserWorker.perform_async(email: "test@babar.com")
    }.to change(UserWorker.jobs, :size).by(1)
  end

  it "instantiate a mirroring creation process" do
    expect(Mirroring::User::Create).to receive(:new).with(email: "test@babar.com")
    UserWorker.new.perform(email: "test@babar.com")
  end
end
