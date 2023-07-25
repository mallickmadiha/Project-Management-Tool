# frozen_string_literal: true

# app/helpers/details_helper.rb
module DetailsHelper
  def create_detail
    detail = Detail.new(detail_params)
    detail.uuid = SecureRandom.hex(10)
    detail
  end

  def render_success_response
    @status = @detail.status
    @users = @detail.users
    @tasks = @detail.tasks
    @id = @detail.id

    render json: { detail: @detail.uuid, id: @detail.id, status: @detail.status,
                   project_id: @detail.project_id, js_id: @id, tasks: @tasks,
                   users: @users, current_user: current_user.id }
  end

  def render_error_response
    render json: { error: 'Failed to create detail' }, status: :unprocessable_entity
  end

  def find_detail
    Detail.find(params[:id])
  end

  def update_users_notification
    @detail_id = params[:id]
    @message = "Status of Feature has been changed to #{@detail.status}"

    @notification = create_notification
    broadcast_notification_to_users
  end

  def create_notification
    Notification.create(message: @message, user_id: current_user.id)
  end

  def broadcast_notification_to_users
    @detail.users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   {
                                     message: @message,
                                     id: @notification.id
                                   })
      send_notification_email_to_user(user)
    end
  end

  def send_notification_email_to_user(user)
    UserMailer.notification_email_status(current_user.email, user.username,
                                         user.email, @detail_id, @detail.status).deliver_later
  end

  def find_users_by_username
    User.where(username: params[:username])
  end

  def add_new_users_to_detail(new_users)
    @detail.users << new_users
  end

  def create_new_notification
    Notification.create(message: @message, user_id: current_user.id)
  end

  def broadcast_notification_to_new_users(new_users)
    new_users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   {
                                     message: @message,
                                     id: @notification.id
                                   })
    end
  end
end
