# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
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

  describe 'scope' do
    context '.mark_as_read_for_user' do
      it 'marks all unread notifications as read for the given user' do
        user = create(:user)
        unread_notification1 = create(:notification, user:, read: false)
        unread_notification2 = create(:notification, user:, read: false)
        read_notification = create(:notification, user:, read: true)
        Notification.mark_as_read_for_user(user)
        unread_notification1.reload
        unread_notification2.reload
        read_notification.reload
        expect(unread_notification1.read).to eq(true)
        expect(unread_notification2.read).to eq(true)
        expect(read_notification.read).to eq(true)
      end
    end

    context '.unread_for_user' do
      it 'returns only the unread notifications for the given user' do
        user = create(:user)
        unread_notification1 = create(:notification, user:, read: false)
        unread_notification2 = create(:notification, user:, read: false)
        unread_notifications = Notification.unread_for_user(user)
        expect(unread_notifications).to match_array([unread_notification1, unread_notification2])
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
