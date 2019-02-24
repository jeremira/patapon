require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {create :user}
  
  describe 'validations' do
    it 'has a valid factory' do
      expect(user).to be_valid
    end
    it 'require an email' do
      user.email = nil
      expect(user).not_to be_valid
    end
    it 'require an unic email' do
      dup_email_user = build :user, email: user.email
      expect(dup_email_user).not_to be_valid
    end
  end
end
