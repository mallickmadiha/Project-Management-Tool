# frozen_string_literal: true

# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  skip_before_action :authenticate_user

  def index
    return render_404_page if current_user.nil?

    @project = Project.new
    @projects = User.find(current_user.id).projects
  end

  def show
    @project = Project.find_by(id: params[:id])
    return render_404_page if @project.nil?
    return render_404_page unless user_belongs_to_project?

    initialize_details
    initialize_flags
    initialize_submit_flags
    initialize_search_items
    initialize_chats

    @project_users = @project.users
  end

  def new
    @project = Project.new
  end

  def create
    @project = build_project_with_user

    if save_project_and_associate_user
      render json: { username: @username, project_id: @project.id }
    else
      render json: { errors: @project.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
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
    @project = Project.find_by(id: params[:project_id])
    return render_404_page if @project.nil?
    return render_404_page unless user_belongs_to_project?

    @users = User.where.not(id: @project.users.pluck(:id))
    @project_users = @project.users
  end

  def update_user_ids
    project = Project.find(params[:project_id])
    return render_404_page if params[:user_id].nil? || project.nil?

    user = User.find(params[:user_id])

    project.users << user
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def fetch_project_details
    @project.details
  end

  def user_belongs_to_project?
    @project.users.include?(current_user)
  end

  def initialize_details
    @details = fetch_project_details
    @detail = Detail.new
  end

  def initialize_chats
    @chats = Chat.all
    @chat = Chat.new
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

  def render_404_page
    render 'partials/_404'
  end

  def build_project_with_user
    project = Project.new(project_params)
    project.user_id = current_user.id
    project
  end

  def save_project_and_associate_user
    @username = current_user.username
    @project.users << current_user
    @project.save
  end
end
