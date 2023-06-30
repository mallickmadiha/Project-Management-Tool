# frozen_string_literal: true

# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index show create]

  def index
    @project = Project.new
    @projects = Project.find_by_sql("SELECT * FROM projects WHERE user_id = #{current_user.id}")
  end

  def show
    @project = Project.find(params[:id])
    @details = @project.details
    # binding.pry
    @backlogs = @details.where(flagType: 'backFlag') || []
    @currentIteration = @details.where(flagType: 'currentIteration')
    @Icebox = @details.where(flagType: 'icebox')
    @icebox_item_submit = 'i'
    @backlog_item_submit = 'b'
    @current_item_submit = 'c'

    @chats = Chat.all
    @chat = Chat.new

    # cookies.signed[:project_id] = @project.id
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(project_params.merge(user_id: current_user.id))
    @project.save
    @username = User.find(@project.user_id).username
    render json: { username: @username }
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

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
