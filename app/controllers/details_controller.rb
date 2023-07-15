# frozen_string_literal: true
# rubocop:disable all

# app/controllers/details_controller.rb
class DetailsController < ApplicationController
  skip_before_action :authenticate_user,
                     only: %i[index show new create edit update destroy change_status update_user_ids elastic_search]

  def index
    @details = Detail.all
  end

  def show
    @detail = Detail.find(params[:id])
  end

  def new
    @detail = Detail.new
  end

  def elastic_search
    query = params.dig(:search_items, :query)
    project_id = params.dig(:search_items, :project_id)
    @project = Project.find(project_id)
    @details = Detail.search(Detail.search_items(query.strip)).records.where(project_id:)

    @chats = Chat.all
    @chat = Chat.new
  end

  def create
    @detail = Detail.new(detail_params)
    @detail.uuid = SecureRandom.hex(10)
    @detail.save
    @status = @detail.status
    @users = @detail.users
    @tasks = @detail.tasks
    @id = @detail.id
    render json: { detail: @detail.uuid, id: @detail.id, status: @detail.status,
                   project_id: @detail.project_id, js_id: @id, tasks: @tasks, users: @users, current_user: current_user.id }
  end

  def edit
    @detail = Detail.find(params[:id])
  end

  def update
    @detail = Detail.update(detail_params)
    redirect_to detail_path(@detail)
  end

  def destroy
    @detail = Detail.find(params[:id])
    @detail.destroy
    redirect_to details_path
  end

  def change_status
    @detail = Detail.find(params[:id])
    @detail.status = params[:status]
    @detail_id = params[:id]
    @message = "Status of Feature #{@detail_id} has been changed to #{@detail.status}"
    @notification = Notification.create(message: @message, user_id: current_user.id)
    @notification.save
    if @detail.save
      @detail.users.each do |user|
        ActionCable.server.broadcast("notifications_#{user.id}",
                                     {
                                       message: @message,
                                       id: @notification.id
                                     })
        UserMailer.notification_email_status(current_user.email, user.username,
                                             user.email, @detail_id, @detail.status).deliver_later
      end
    else
      @message = 'An error has occurred'
    end
  end

  def update_user_ids
    @detail = Detail.find(params[:id])
    @project_id = params[:project_id]
    @users = User.where(email: params[:email])
    new_users = @users - @detail.users
    @detail.users << new_users
    @detail_id = params[:id]

    @message = "You have been Added to Feature #{@detail_id}"
    @notification = Notification.create(message: @message, user_id: current_user.id)
    @notification.save

    new_users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   {
                                     message: @message,
                                     id: @notification.id
                                   })
    end
  end

  private

  def detail_params
    params.require(:detail).permit(:title, :description, :project_id, :flagType, file: [])
  end
end
