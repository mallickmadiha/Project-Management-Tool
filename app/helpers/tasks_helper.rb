# frozen_string_literal: true

# app/helpers/tasks_helper.rb
module TasksHelper
  def find_project
    Project.find(params[:project_id])
  end

  def find_detail(project)
    project.details.find(params[:detail_id])
  end

  def build_task(detail)
    detail.tasks.build(task_params)
  end

  def count_completed_tasks(detail)
    detail.tasks.Done.count
  end

  def render_success_response(completed_tasks_count, total_tasks_count)
    render json: { message: 'Task created successfully', id: @task.id, completedTasksCount: completed_tasks_count,
                   totalTasksCount: total_tasks_count }, status: :ok
  end

  def render_error_response
    render json: { error: 'Failed to create task' }, status: :unprocessable_entity
  end

  def update_task_record
    @task.update(task_update_params)
  end

  def render_update_success_response
    completed_tasks_count = @detail.tasks.Done.count
    total_tasks_count = @detail.tasks.count

    render json: {
      message: 'Task updated successfully',
      completedTasksCount: completed_tasks_count,
      totalTasksCount: total_tasks_count
    }
  end

  def render_update_error_response
    render json: { error: 'Failed to update task' }, status: :unprocessable_entity
  end
end
