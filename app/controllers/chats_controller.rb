# frozen_string_literal: true

# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  include ChatsHelper
  skip_before_action :authenticate_user

  def new
    @chat = Chat.new
  end

  def create
    initialize_chat_data

    if @chat.save
      broadcast_chat_message
      create_and_broadcast_notifications
      send_notification_emails_to_detail_users

      render json: { message: 'Chat message sent successfully.', chat: @chat }
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :sender_id, :detail_id)
  end
end
