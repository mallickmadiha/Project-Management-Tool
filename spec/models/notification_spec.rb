# spec/models/notification_spec.rb
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it 'is not valid without a message' do
      notification = FactoryBot.build(:notification, message: nil)

      expect(notification).not_to be_valid
      expect(notification.errors[:message]).to include("Message can't be blank")
    end

    it 'is not valid without a user' do
      notification = FactoryBot.build(:notification, user: nil)

      expect(notification).not_to be_valid
      expect(notification.errors[:user_id]).to include("User can't be blank")
    end
  end
end
