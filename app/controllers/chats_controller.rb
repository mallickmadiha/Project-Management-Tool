# frozen_string_literal: true

# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  skip_before_action :authenticate_user

  def new
    @chat = Chat.new
  end

  def create
    initialize_chat_data
    if @chat.save
      ActionCable.server.broadcast("chat_channel_#{@project_id}",
                                   { chat: @chat, sender_username: @sender_username, detailsId: @details_id })
      create_and_broadcast_notifications(@details_id)
      send_notification_emails_to_detail_users(@project_id)
      render json: { message: 'Comment added successfully.', chat: @chat }
    else
      @message = @chat.errors.full_messages.join(', ')
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :sender_id, :detail_id)
  end

  def initialize_chat_data
    @chat = Chat.new(chat_params)
    @details_id = chat_params[:detail_id]
    @project_id = Detail.find(@details_id).project_id
    @detail = Detail.find(@details_id)
    @sender_username = User.find(chat_params[:sender_id]).username
    @message = "A new comment has been added to feature #{@detail.title}"
  end

  def create_and_broadcast_notifications(details_id)
    @notification = Notification.create(message: @message, user_id: current_user.id)
    @detail = Detail.find(details_id)
    mentioned_usernames = @chat.message.scan(/@(\w+)/).flatten
    mentioned_users = User.mentioned_users(mentioned_usernames)
    mentioned_users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   { message: "You have been mentioned in feature #{@detail.title}",
                                     id: @notification.id })
    end
  end

  def send_notification_emails_to_detail_users(project_id)
    @project = Project.find(project_id)
    @project.users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}", { message: @message, id: @notification.id })
      detail = Detail.find(@details_id)
      UserMailer.notification_email(current_user.email, user.username, user.email, detail.title,
                                    detail.description).deliver_later
    end
  end
end
