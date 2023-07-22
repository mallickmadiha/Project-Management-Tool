# frozen_string_literal: true

# spec/helpers/sessions_helper_spec.rb
require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#find_user_by_email' do
    it 'returns the user with the given email' do
      found_user = helper.find_user_by_email(user.email)
      expect(found_user).to eq(user)
    end

    it 'returns nil when user with the given email does not exist' do
      found_user = helper.find_user_by_email('nonexistent@example.com')
      expect(found_user).to be_nil
    end
  end

  describe '#user_session_set' do
    it 'sets session and cookie with user id' do
      helper.user_session_set(user)
      expect(session[:id]).to eq(user.id)
      expect(cookies.signed[:user_id]).to eq(user.id)
    end
  end
end
