# frozen_string_literal: true

# spec/helpers/application_helper_spec.rb
require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ApplicationHelper, type: :helper do
  describe '#current_user' do
    it 'returns the current user if session[:id] is present' do
      user = create(:user)
      session[:id] = user.id

      expect(helper.current_user).to eq(user)
    end

    it 'returns nil if session[:id] is nil' do
      session[:id] = nil

      expect(helper.current_user).to be_nil
    end
  end

  describe '#logged_in?' do
    it 'returns true when a current user is present' do
      user = create(:user)
      session[:id] = user.id

      expect(helper.logged_in?).to be true
    end

    it 'returns false when there is no current user' do
      session[:id] = nil

      expect(helper.logged_in?).to be false
    end
  end

  describe '#error_messages' do
    let(:user) { User.new }

    it 'returns error messages for a specified field when errors are present' do
      user.errors.add(:name, "can't be blank")

      expect(helper.error_messages(user, :name)).to eq("can't be blank")
    end

    it 'returns nil when there are no errors for the specified field' do
      expect(helper.error_messages(user, :name)).to be_nil
    end

    it 'returns nil when there are no errors on the object' do
      expect(helper.error_messages(user, :name)).to be_nil
    end
  end
end
# rubocop:enable Metrics/BlockLength
