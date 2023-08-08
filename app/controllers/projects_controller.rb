# frozen_string_literal: true

# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  include ProjectsHelper
  skip_before_action :authenticate_user

  def index
    return render_404_page if current_user.nil?

    @project = Project.new
    @projects = current_user.projects
  end

  def show
    @project = Project.find_by(id: params[:id])
    return render_404_page if @project.nil?
    return render_404_page unless @project.users.include?(current_user)

    @details = @project.details
    @detail = Detail.new
    initialize_flags
    initialize_submit_flags
    initialize_chats
    @task = Task.new

    @project_users = @project.users
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if save_project_and_associate_user
      render json: { username: @username, project_id: @project.id }
    else
      render json: { errors: @project.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def adduser
    @project = Project.find_by(id: params[:project_id])
    return render_404_page if @project.nil?
    return render_404_page unless @project.users.include?(current_user)

    @users = User.not_in_project(@project)
    @project_users = @project.users
  end

  def update_user_ids
    project = Project.find_by(id: params[:project_id])
    user_ids = Array(params[:user_id])
    if user_ids.empty?
      flash.now[:error] = 'Please Select Users to Add to the Project'
    else
      @users = User.find(user_ids)
      project.users << @users
      flash.now[:success] = 'Users Added Successfully to the Project'
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
