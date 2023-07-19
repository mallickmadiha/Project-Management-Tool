# frozen_string_literal: true

require 'rails_helper'

# spec/models/user_spec.rb
# rubocop:disable Metrics/BlockLength
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
end
# rubocop:enable Metrics/BlockLength
