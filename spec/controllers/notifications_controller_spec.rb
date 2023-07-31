# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'POST #mark_read' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:id] = user.id
      end

      it 'marks all unread notifications as read' do
        notification1 = create(:notification, user:, read: false)
        notification2 = create(:notification, user:, read: false)
        notification3 = create(:notification, user:, read: true)

        expect do
          post :mark_read
        end.to change { user.notifications.where(read: false).count }.from(2).to(0)

        expect(notification1.reload.read).to eq(true)
        expect(notification2.reload.read).to eq(true)
        expect(notification3.reload.read).to eq(true)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
