# frozen_string_literal: true

# app/controllers/chats_controller.rb
class ChatsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[new create last_message]
  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @details_id = chat_params[:detail_id]
    # get the project id from the details id
    @project_id = Detail.find(@details_id).project_id
    if @chat.save
      ActionCable.server.broadcast("chat_channel_#{@project_id}",
                                   { chat: @chat, detailsId: chat_params[:detail_id] })
      # render json: { message: 'Chat message sent successfully.', chat: @chat }
    else
      render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def last_message
    @last_message = Chat.where(details_id: params[:details_id]).last
    # @last_message.destroy
    render json: { last_message: @last_message }
  end

  private

  def chat_params
    # params.require(:chat_message).permit(:message, :sender_id, :recipient_id, mentioned_user_ids: [])
    params.require(:chat).permit(:message, :sender_id, :detail_id)
  end
end
