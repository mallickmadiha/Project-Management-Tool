# frozen_string_literal: true

# app/controllers/room_controller.rb
class RoomController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index]

  def index
    @chats = Chat.all
    @chat = Chat.new
  end
end
