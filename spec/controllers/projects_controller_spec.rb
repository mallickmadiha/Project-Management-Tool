# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe ProjectsController, type: :controller do
  describe 'GET #index' do
    context 'when user is logged in' do
      let(:user) { create(:user) }
      let!(:project1) { create(:project, user:) }
      let!(:project2) { create(:project, user:) }
      let!(:other_project) { create(:project) }

      before do
        session[:id] = user.id
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root path' do
        session[:user_id] = nil
        get :index
      end
    end
  end
  describe 'GET #show' do
    context 'when project belongs to the current user' do
      let(:user) { create(:user) }
      let(:project) { create(:project, user:) }
      let!(:detail1) { create(:detail, project:) }
      let!(:detail2) { create(:detail, project:) }

      before do
        session[:id] = user.id
        get :show, params: { id: project.id }
      end

      it 'renders the show template' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template('partials/_404')
      end

      it 'assigns the project and details' do
        expect(assigns(:project)).to eq(project)
      end
    end

    context 'when project does not belong to the current user' do
      let(:user) { create(:user) }
      let(:project) { create(:project) }

      before do
        session[:id] = user.id
      end

      it 'renders the 404 partial' do
        get :show, params: { id: project.id }
        expect(response).to render_template('partials/_404')
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:id] = user.id
      end
      context 'with valid params' do
        let(:valid_params) { { project: { name: 'New Project' } } }

        it 'creates a new project and redirects to projects path' do
          expect do
            post :create, params: valid_params
          end.to change(Project, :count).by(1)

          expect(response).to have_http_status(:success)
          expect(response.body).to eq({ username: user.username, project_id: Project.last.id }.to_json)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { project: { name: '' } } }

        it 'does not create a new project and returns error response' do
          expect do
            post :create, params: invalid_params
          end.not_to change(Project, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include('errors')
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
