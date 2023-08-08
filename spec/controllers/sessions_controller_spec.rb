# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com', password: 'Madiha@123##') }

  describe 'GET #new' do
    it 'renders the login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to projects path' do
        post :create, params: { email: 'user@example.com', password: 'Madiha@123##' }
      end
    end

    context 'with invalid credentials' do
      it 'redirects to root path with an error flash' do
        post :create, params: { email: 'user@example.com', password: 'wrong_password' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user and redirects to root path' do
      session[:id] = user.id
      delete :destroy
      expect(response).to redirect_to(root_path)
      expect(session[:id]).to be_nil
    end
  end

  describe 'GET #omniauth' do
    before do
      request.env['omniauth.auth'] =
        OmniAuth.config.add_mock(:provider_name, { uid: 'uid', info: { email: 'user@example.com' } })
    end

    it 'processes the user and redirects to projects path' do
      get :omniauth, params: { provider: 'provider_name' }
    end
  end
end
# rubocop:enable Metrics/BlockLength
