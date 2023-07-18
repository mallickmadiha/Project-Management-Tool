# frozen_string_literal: true

# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index show new create edit update destroy adduser update_user_ids]

  def index
    @project = Project.new
    @projects = User.find(current_user.id).projects
  end

  def show
    @project = Project.find(params[:id])
    @details = fetch_project_details
    @detail = Detail.new
    initialize_flags
    initialize_submit_flags
    initialize_search_items
    @chats = Chat.all
    @chat = Chat.new
    @project_users = @project.users
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(project_params.merge(user_id: current_user.id))
    @username = User.find(@project.user_id).username
    user = User.find(current_user.id)
    @project.users << user
    @project.save
    render json: { username: @username, project_id: @project.id }
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.update(project_params)
    redirect_to projects_path(@project)
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end

  def adduser
    @project = Project.find(params[:project_id])
    @users = User.where.not(id: @project.users.pluck(:id))
    @project_users = @project.users
  end

  def update_user_ids
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    project.users << user
    redirect_to '/projects'
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def fetch_project_details
    @project.details
  end

  def initialize_flags
    @backlogs = @details.where(flagType: 'backFlag') || []
    @current = @details.where(flagType: 'currentIteration')
    @icebox = @details.where(flagType: 'icebox')
  end

  def initialize_submit_flags
    @icebox_item_submit = 'i'
    @backlog_item_submit = 'b'
    @current_item_submit = 'c'
  end

  def initialize_search_items
    @search_items = 's'
  end
end
