# rubocop:disable all
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { FactoryBot.build(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
      user.username = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a non-word username' do
      user.username = 'user name'
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a too long email' do
      user.email = "#{'a' * 256}@example.com"
      expect(user).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      user.email = 'invalid_email'
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      FactoryBot.create(:user, email: user.email)
      expect(user).not_to be_valid
    end

    it 'is not valid without a password digest' do
      user.password_digest = nil
      expect(user).not_to be_valid
    end
  end

  describe '.from_omniauth' do
    let(:email) { 'test@example.com' }
    let(:username) { 'testuser' }
    let(:auth) do
      double('auth', info: double('info', email: email, name: username))
    end

    context 'when the user with the given email already exists' do
      let!(:existing_user) { create(:user, email: email, username: username) }

      it 'returns the existing user' do
        allow(User).to receive(:find_by).with(email: email).and_return(existing_user)
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end

    context 'when the user with the given email does not exist' do
      it 'creates a new user with the provided email and username' do
        allow(User).to receive(:find_by).with(email: email).and_return(nil)
        expect(User).to receive(:create).with(email: email, username: username).and_call_original
        user = User.from_omniauth(auth)
        expect(user.email).to eq(email)
        expect(user.username).to eq(username)
      end
    end
  end
end
