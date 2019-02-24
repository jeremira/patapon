require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  it "inherit from ApplicationController" do
    expect(described_class).to be < ActionController::API
  end
end
