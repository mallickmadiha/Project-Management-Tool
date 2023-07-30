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
        user = FactoryBot.build(:user, username: 'john_doe', email: 'john@example.com', password: 'password')

        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end

    context 'negative test cases' do
      it 'is not valid without a username' do
        user = FactoryBot.build(:user, username: nil, email: 'john@example.com', password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include("can't be blank")
      end

      it 'is not valid with a username containing spaces' do
        user = FactoryBot.build(:user, username: 'john doe', email: 'john@example.com', password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include('must be a single word')
      end

      it 'is not valid without an email' do
        user = FactoryBot.build(:user, username: 'john_doe', email: nil, password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is not valid with an invalid email format' do
        user = FactoryBot.build(:user, username: 'john_doe', email: 'john@example', password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('must be a valid email address')
      end

      it 'is not valid if the same username exists for another user' do
        FactoryBot.create(:user, username: 'john_doe', email: 'john@example.com', password: 'password')
        user = FactoryBot.build(:user, username: 'john_doe', email: 'another_john@example.com', password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:username]).to include('is already taken for other user')
      end

      it 'is not valid if the same email exists for another user' do
        FactoryBot.create(:user, username: 'john_doe', email: 'john@example.com', password: 'password')
        user = FactoryBot.build(:user, username: 'another_john', email: 'john@example.com', password: 'password')

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('is already taken for other user')
      end

      it 'is not valid without a password' do
        user = FactoryBot.build(:user, username: 'john_doe', email: 'john@example.com', password: nil)

        expect(user).not_to be_valid
        expect(user.errors[:password_digest]).to include("can't be blank")
      end
    end
  end

  describe '.from_omniauth' do
    let(:email) { 'test@example.com' }
    let(:username) { 'testuser' }
    let(:auth) do
      double('auth', info: double('info', email:, name: username))
    end

    context 'when the user with the given email already exists' do
      let!(:existing_user) { create(:user, email:, username:) }

      it 'returns the existing user' do
        allow(User).to receive(:find_by).with(email:).and_return(existing_user)
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end

    context 'when the user with the given email does not exist' do
      it 'creates a new user with the provided email and username' do
        allow(User).to receive(:find_by).with(email:).and_return(nil)
        expect(User).to receive(:create).with(email:, username:).and_call_original
        user = User.from_omniauth(auth)
        expect(user.email).to eq(email)
        expect(user.username).to eq(username)
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
