require "rails_helper"

RSpec.describe "User Create", :type => :request do

  describe "With valid params" do
    
    it "render 200" do
      post api_v1_users_path
      expect(response.status).to eq 200
    end
  end
end
