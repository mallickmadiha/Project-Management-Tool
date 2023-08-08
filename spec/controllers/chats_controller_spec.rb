# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ChatsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:detail) { create(:detail, project:) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'when the chat is successfully created' do
      let(:chat_params) do
        {
          chat: {
            message: 'Test message',
            sender_id: user.id,
            detail_id: detail.id
          }
        }
      end
    end

    context 'when the chat creation fails' do
      let(:invalid_chat_params) do
        {
          chat: {
            message: '',
            sender_id: user.id,
            detail_id: detail.id
          }
        }
      end

      it 'is valid with all required attributes' do
        chat = Chat.new(message: 'Test message', sender: user, detail:)
        expect(chat).to be_valid
      end

      it 'is not valid without a message' do
        chat = Chat.new(sender: user, detail:)
        expect(chat).not_to be_valid
        expect(chat.errors[:message]).to include('must be between 5 (min) and 255 (max) characters')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
