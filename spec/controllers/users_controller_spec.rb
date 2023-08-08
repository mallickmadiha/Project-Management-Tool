# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new user as @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        { username: 'testuser', email: 'test@example.com', password: 'Madiha@123##',
          password_confirmation: 'Madiha@123##' }
      end

      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_params }
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        { user: { username: '', email: 'test@example.com', password: 'Madiha@123##',
                  password_confirmation: 'invalid' } }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: invalid_params
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
