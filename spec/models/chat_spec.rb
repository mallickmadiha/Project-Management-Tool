# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Chat, type: :model do
  describe 'associations' do
    it 'belongs to a sender (User)' do
      association = described_class.reflect_on_association(:sender)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
    end

    it 'belongs to a detail' do
      association = described_class.reflect_on_association(:detail)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with valid attributes' do
        user = FactoryBot.create(:user)
        detail = FactoryBot.create(:detail)
        chat = FactoryBot.build(:chat, message: 'Valid message', sender: user, detail:)

        expect(chat).to be_valid
        expect(chat.errors).to be_empty
      end

      it 'is valid with a message of maximum length' do
        user = FactoryBot.create(:user)
        detail = FactoryBot.create(:detail)
        long_message = 'a' * 255
        chat = FactoryBot.build(:chat, message: long_message, sender: user, detail:)

        expect(chat).to be_valid
        expect(chat.errors).to be_empty
      end
    end

    context 'negative test cases' do
      it 'is not valid without a sender' do
        detail = FactoryBot.create(:detail)
        chat = FactoryBot.build(:chat, sender: nil, detail:)

        expect(chat).not_to be_valid
        expect(chat.errors[:sender]).to include('must exist')
      end

      it 'is not valid without a detail' do
        user = FactoryBot.create(:user)
        chat = FactoryBot.build(:chat, message: 'Invalid message', sender: user, detail: nil)

        expect(chat).not_to be_valid
        expect(chat.errors[:detail]).to include('must exist')
      end

      it 'is not valid without a message' do
        user = FactoryBot.create(:user)
        detail = FactoryBot.create(:detail)
        chat = FactoryBot.build(:chat, message: nil, sender: user, detail:)

        expect(chat).not_to be_valid
        expect(chat.errors[:message]).to include("Message can't be blank")
      end

      it 'is not valid if message exceeds maximum length' do
        user = FactoryBot.create(:user)
        detail = FactoryBot.create(:detail)
        long_message = 'a' * 256
        chat = FactoryBot.build(:chat, message: long_message, sender: user, detail:)

        expect(chat).not_to be_valid
        expect(chat.errors[:message]).to include('Message is too long (maximum is 255 characters)')
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
