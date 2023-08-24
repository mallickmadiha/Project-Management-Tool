# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has and belongs to many details' do
      association = described_class.reflect_on_association(:details)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has and belongs to many projects' do
      association = described_class.reflect_on_association(:projects)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has many notifications with dependent destroy' do
      association = described_class.reflect_on_association(:notifications)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many sent_chats with foreign key as sender_id' do
      association = described_class.reflect_on_association(:sent_chats)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq('Chat')
      expect(association.options[:foreign_key]).to eq('sender_id')
    end
  end

  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with valid attributes' do
        user = FactoryBot.build(:user, username: 'johndoe', email: 'john@example.com', password: 'Madiha@123##')

        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end

    context 'negative test cases' do
      it 'is not valid without a username' do
        user = FactoryBot.build(:user, username: nil, email: 'john@example.com', password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end

      it 'is not valid with a username containing spaces' do
        user = FactoryBot.build(:user, username: 'john doe', email: 'john@example.com', password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include('must be a single word (no spaces allowed)')
      end

      it 'is not valid without an email' do
        user = FactoryBot.build(:user, username: 'johndoe', email: nil, password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is not valid with an invalid email format' do
        user = FactoryBot.build(:user, username: 'johndoe', email: 'john@example', password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('must be a valid email address')
      end

      it 'is not valid if the same username exists for another user' do
        FactoryBot.create(:user, username: 'johndoe', email: 'john@example.com', password: 'Madiha@123##')
        user = FactoryBot.build(:user, username: 'johndoe', email: 'another_john@example.com', password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include('is already taken for other user')
      end

      it 'is not valid if the same email exists for another user' do
        FactoryBot.create(:user, username: 'johndoe', email: 'john@example.com', password: 'Madiha@123##')
        user = FactoryBot.build(:user, username: 'another_john', email: 'john@example.com', password: 'Madiha@123##')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is already taken for other user')
      end

      it 'is not valid without a password' do
        user = FactoryBot.build(:user, username: 'johndoe', email: 'john@example.com', password: nil)

        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end
    end
  end

  describe 'scopes' do
    context '.mentioned_users' do
      it 'returns users with mentioned usernames' do
        user1 = create(:user, username: 'johndoe')
        user2 = create(:user, username: 'janesmith')
        mentioned_usernames = %w[johndoe janesmith alice]
        result = User.mentioned_users(mentioned_usernames)
        expect(result).to contain_exactly(user1, user2)
      end
    end

  end
end
# rubocop: enable Metrics/BlockLength
