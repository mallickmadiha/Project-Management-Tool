# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello World'
    end
  end

  describe '#authenticate_user' do
    context 'when session[:id] is present' do
      it 'redirects to projects_path' do
        user = create(:user)
        session[:id] = user.id
        get :index
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'when session[:id] is nil' do
      it 'does not redirect and continues to the action' do
        session[:id] = nil
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('Hello World')
      end
    end
  end

  describe '#current_user' do
    context 'when session[:id] points to an existing user' do
      it 'returns the current user' do
        user = create(:user)
        session[:id] = user.id
        current_user = controller.send(:current_user)
        expect(current_user).to eq(user)
      end
    end

    context 'when session[:id] does not point to any existing user' do
      it 'returns nil' do
        session[:id] = 1234
        current_user = controller.send(:current_user)
        expect(current_user).to be_nil
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
