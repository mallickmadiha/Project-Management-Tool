# frozen_string_literal: true

require 'rails_helper'

# spec/models/notification_spec.rb
RSpec.describe Notification, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with a message' do
        notification = FactoryBot.build(:notification, message: 'New notification', user: FactoryBot.create(:user))

        expect(notification).to be_valid
      end
    end

    context 'negative test cases' do
      it 'is not valid without a message' do
        notification = FactoryBot.build(:notification, message: nil)

        expect(notification).not_to be_valid
        expect(notification.errors[:message]).to include("Message can't be blank")
      end
    end
  end
end
