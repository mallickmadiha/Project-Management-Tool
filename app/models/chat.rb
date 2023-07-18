# frozen_string_literal: true

# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :detail

  validates :message, presence: { message: "Message can't be blank" },
                      length: { maximum: 255, message: 'Message is too long (maximum is 255 characters)' }

  def self.create_and_notify(chat_params, current_user)
    chat = create_chat(chat_params)

    if chat.valid?
      notify_chat_creation(chat, chat_params, current_user)
      notify_users(chat_params, current_user, chat)
      { success: true, chat: }
    else
      { success: false, errors: chat.errors.full_messages }
    end
  end

  def self.create_chat(chat_params)
    Chat.new(chat_params)
  end

  def self.notify_chat_creation(chat, chat_params, current_user)
    project_id = find_project_id(chat_params)
    sender_username = find_sender_username(chat_params)
    message = "A new comment has been added to feature #{chat_params[:detail_id]}"

    ActionCable.server.broadcast("chat_channel_#{project_id}",
                                 { chat:, sender_username:,
                                   detailsId: chat_params[:detail_id] })

    create_notification(message, current_user)
  end

  def self.find_project_id(chat_params)
    Detail.find(chat_params[:detail_id]).project_id
  end

  def self.find_sender_username(chat_params)
    User.find(chat_params[:sender_id]).username
  end

  def self.create_notification(message, current_user)
    notification = Notification.create(message:, user_id: current_user.id)
    notification.save
  end

  def self.notify_users(chat_params, current_user, chat)
    detail = find_detail(chat_params)
    detail.users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   {
                                     message: "A new comment has been added to feature #{chat_params[:detail_id]}",
                                     id: chat.notification.id
                                   })
      UserMailer.notification_email(current_user.email, user.username,
                                    user.email, chat_params[:detail_id]).deliver_later
    end
  end

  def self.find_detail(chat_params)
    Detail.find(chat_params[:detail_id])
  end
end
