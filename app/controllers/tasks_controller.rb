# frozen_string_literal: true

# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  include TasksHelper
  skip_before_action :authenticate_user

  def new
    @task = Task.new
  end

  def create
    project = find_project
    detail = find_detail(project)

    @task = build_task(detail)

    completed_tasks_count = count_completed_tasks(detail)
    total_tasks_count = detail.tasks.count

    if @task.save
      render_success_response(completed_tasks_count, total_tasks_count)
    else
      render_error_response
    end
  end

  def update
    @project = Project.find(params[:project_id])
    @detail = @project.details.find(params[:detail_id])
    @task = @detail.tasks.find(params[:id])

    if update_task_record
      render_update_success_response
    else
      render_update_error_response
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
