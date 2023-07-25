# frozen_string_literal: true

# app/helpers/chats_helper.rb
module ChatsHelper
  def initialize_chat_data
    @chat = Chat.new(chat_params)
    @details_id = chat_params[:detail_id]
    @project_id = find_project_id_from_detail(@details_id)
    @detail = find_detail(@details_id)
    @sender_username = find_sender_username(chat_params[:sender_id])
    @message = 'A new comment has been added to feature'
  end

  def find_detail(detail_id)
    Detail.find(detail_id)
  end

  def create_notification(message, user_id)
    Notification.create(message:, user_id:)
  end

  def broadcast_notification(notification, message, user_id)
    ActionCable.server.broadcast("notifications_#{user_id}", { message:, id: notification.id })
  end

  def extract_mentioned_users(message)
    mentioned_usernames = message.scan(/@(\w+)/).flatten
    User.where(username: mentioned_usernames)
  end

  def send_notification_email(sender_email, recipient_username, recipient_email, details_id)
    UserMailer.notification_email(sender_email, recipient_username, recipient_email, details_id).deliver_later
  end

  def find_project_id_from_detail(detail_id)
    Detail.find(detail_id).project_id
  end

  def find_sender_username(sender_id)
    User.find(sender_id).username
  end

  def broadcast_chat_message
    ActionCable.server.broadcast("chat_channel_#{@project_id}",
                                 { chat: @chat, sender_username: @sender_username, detailsId: @details_id })
  end

  def create_and_broadcast_notifications
    @notification = create_notification(@message, current_user.id)
    mentioned_users = extract_mentioned_users(@chat.message)
    mentioned_users.each do |user|
      broadcast_notification(@notification, 'You have been mentioned in a feature', user.id)
    end
  end

  def send_notification_emails_to_detail_users
    @detail.users.each do |user|
      broadcast_notification(@notification, @message, user.id)
      send_notification_email(current_user.email, user.username, user.email, @details_id)
    end
  end
end
