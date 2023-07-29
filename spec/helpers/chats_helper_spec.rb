# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatsHelper, type: :helper do
  let(:user) { create(:user) }
  let(:detail) { create(:detail) }
  let(:project) { create(:project) }

  describe '#broadcast_notification' do
    it 'broadcasts the notification to ActionCable server' do
      message = 'Test notification message'
      notification = create(:notification, user:, message:)

      expect(ActionCable.server).to receive(:broadcast).with("notifications_#{user.id}",
                                                             { message:, id: notification.id })

      helper.broadcast_notification(notification, message, user.id)
    end
  end

  describe '#send_notification_email' do
    it 'sends notification email' do
      recipient = create(:user)
      mailer = instance_double(ActionMailer::MessageDelivery)

      expect(UserMailer).to receive(:notification_email).with(user.email, recipient.username, recipient.email,
                                                              detail.title, detail.description).and_return(mailer)
      expect(mailer).to receive(:deliver_later)

      helper.send_notification_email(user.email, recipient.username, recipient.email, detail.title,
                                     detail.description)
    end
  end
end
