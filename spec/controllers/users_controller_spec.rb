require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  it "inherit from ApplicationController" do
    expect(described_class).to be < ApplicationController
  end
end
