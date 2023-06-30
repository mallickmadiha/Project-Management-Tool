# frozen_string_literal: true

# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params['project_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    Chat.create!(detail_id: data['details_id'], sender_id: data['sender_id'], message: data['message'])
  end
end
