# frozen_string_literal: true

# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create]

  def new
    @chat = Chat.new
  end

  def create
    result = Chat.create_and_notify(chat_params, current_user)

    if result[:success]
      render json: { message: 'Chat message sent successfully.', chat: result[:chat] }
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :sender_id, :detail_id)
  end
end
