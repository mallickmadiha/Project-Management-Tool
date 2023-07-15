# frozen_string_literal: true

require 'rails_helper'

# spec/models/chat_spec.rb
RSpec.describe Chat, type: :model do
  describe 'validations' do
    it 'is not valid without a message' do
      chat = FactoryBot.build(:chat, message: nil)

      expect(chat).not_to be_valid
      expect(chat.errors[:message]).to include("Message can't be blank")
    end

    it 'is not valid if message exceeds 255 characters' do
      chat = FactoryBot.build(:chat, message: 'a' * 256)

      expect(chat).not_to be_valid
      expect(chat.errors[:message]).to include('Message is too long (maximum is 255 characters)')
    end
  end
end
