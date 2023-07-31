# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:detail) { create(:detail, project:) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task and renders success response' do
        allow(controller).to receive(:current_user).and_return(user)

        completed_tasks_count = detail.tasks.where(status: 'Added').count
        total_tasks_count = detail.tasks.count

        post :create, params: { task: { name: 'New Task' }, project_id: project.id, detail_id: detail.id }

        expect(response).to have_http_status(:success)

        expect(Task.count).to eq(1)
        new_task = Task.last
        expect(new_task.name).to eq('New Task')
        expect(new_task.detail).to eq(detail)

        expect(response.body).to eq({
          message: 'Task created successfully',
          id: new_task.id,
          completedTasksCount: completed_tasks_count,
          totalTasksCount: total_tasks_count
        }.to_json)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:task) { create(:task, detail:) }

    context 'with valid params' do
      it 'updates the task and renders success response' do
        allow(controller).to receive(:current_user).and_return(user)

        patch :update, params: { task: { status: 'Done' }, project_id: project.id, detail_id: detail.id, id: task.id }

        expect(response).to have_http_status(:success)
        expect(task.reload.status).to eq('Done')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
