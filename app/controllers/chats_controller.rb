# frozen_string_literal: true

# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  # skip_before_action :authenticate_user, only: %i[new create]
  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @details_id = chat_params[:detail_id]
    # get the project id from the details id
    @project_id = Detail.find(@details_id).project_id
    @detail = Detail.find(@details_id)
    @message = "A new comment has been added to feature #{@details_id}"
    if @chat.save
      # mentioned_usernames = @chat.message.scan(/@(\w+)/).flatten
      # mentioned_users = User.where(username: mentioned_usernames)
      ActionCable.server.broadcast("chat_channel_#{@project_id}",
                                   { chat: @chat, detailsId: chat_params[:detail_id] })
      @notification = Notification.create(message: @message, user_id: current_user.id)
      @notification.save
      @detail.users.each do |user|
        ActionCable.server.broadcast("notifications_#{user.id}",
                                     {
                                       message: @message,
                                       id: @notification.id
                                     })
        UserMailer.notification_email(current_user.email, user.username,
                                      user.email, @details_id).deliver_later
      end
      render json: { message: 'Chat message sent successfully.', chat: @chat }
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    # params.require(:chat_message).permit(:message, :sender_id, :recipient_id, mentioned_user_ids: [])
    params.require(:chat).permit(:message, :sender_id, :detail_id)
  end
end
