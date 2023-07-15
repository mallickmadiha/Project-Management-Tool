# frozen_string_literal: true

require 'rails_helper'

# spec/models/notification_spec.rb
RSpec.describe Notification, type: :model do
  describe 'validations' do
    it 'is not valid without a message' do
      notification = FactoryBot.build(:notification, message: nil)

      expect(notification).not_to be_valid
      expect(notification.errors[:message]).to include("Message can't be blank")
    end
  end
end
