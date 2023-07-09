# frozen_string_literal: true

# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  # skip_before_action :authenticate_user, only: %i[new create update]

  def new
    @task = Task.new
  end

  def create
    project = Project.find(params[:project_id])
    detail = project.details.find(params[:detail_id])
    @task = detail.tasks.build(task_params)

    completed_tasks_count = detail.tasks.Done.count
    total_tasks_count = detail.tasks.count

    if @task.save
      render json: { message: 'Task created successfully', id: @task.id, completedTasksCount: completed_tasks_count,
                     totalTasksCount: total_tasks_count }, status: :ok
    else
      render json: { error: 'Failed to create task' }, status: :unprocessable_entity
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @detail = @project.details.find(params[:detail_id])
    @task = @detail.tasks.find(params[:id])

    if @task.update(task_update_params)
      completed_tasks_count = @detail.tasks.Done.count
      total_tasks_count = @detail.tasks.count

      render json: {
        message: 'Task updated successfully',
        completedTasksCount: completed_tasks_count,
        totalTasksCount: total_tasks_count
      }
    else
      render json: { error: 'Failed to update task' }, status: :unprocessable_entity
    end
  end

  private

  def task_update_params
    params.require(:task).permit(:status)
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
