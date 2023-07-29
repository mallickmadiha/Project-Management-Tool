# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe TasksHelper, type: :helper do
  let(:user) { create(:user) }
  let(:project) { create(:project, user:) }
  let(:detail) { create(:detail, project:) }
  let(:task_params) { attributes_for(:task) }

  describe '#find_project' do
    it 'finds the correct project' do
      params[:project_id] = project.id

      expect(helper.find_project).to eq(project)
    end
  end

  describe '#find_detail' do
    it 'finds the correct detail' do
      params[:project_id] = project.id
      params[:detail_id] = detail.id

      expect(helper.find_detail(project)).to eq(detail)
    end
  end

  describe '#count_completed_tasks' do
    it 'counts the completed tasks within a detail' do
      create_list(:task, 3, detail:, status: 'Done')

      completed_tasks_count = helper.count_completed_tasks(detail)

      expect(completed_tasks_count).to eq(3)
    end
  end
  describe '#render_success_response' do
    it 'renders a success response JSON' do
      task = create(:task, detail:)

      expect(helper).to receive(:render).with(
        json: {
          message: 'Task created successfully',
          id: task.id,
          completedTasksCount: 0,
          totalTasksCount: 1
        },
        status: :ok
      )

      helper.instance_variable_set(:@task, task)
      helper.render_success_response(0, 1)
    end
  end
  describe '#render_error_response' do
    it 'renders an error response JSON with status :unprocessable_entity' do
      expect(helper).to receive(:render).with(
        json: { error: 'Failed to create task' },
        status: :unprocessable_entity
      )

      helper.render_error_response
    end
  end

  describe '#render_update_success_response' do
    it 'renders a success response JSON for task update' do
      task = create(:task, detail:)

      # Mark one task as completed
      task.update(status: 'Done')

      expect(helper).to receive(:render).with(
        json: {
          message: 'Task updated successfully',
          completedTasksCount: 1,
          totalTasksCount: 1
        }
      )

      helper.instance_variable_set(:@detail, detail)
      helper.render_update_success_response
    end
  end

  describe '#render_update_error_response' do
    it 'renders an error response JSON for task update with status :unprocessable_entity' do
      expect(helper).to receive(:render).with(
        json: { error: 'Failed to update task' },
        status: :unprocessable_entity
      )

      helper.render_update_error_response
    end
  end
end
# rubocop:enable Metrics/BlockLength
