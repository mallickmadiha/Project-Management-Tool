# frozen_string_literal: true

# app/controllers/details_controller.rb
class DetailsController < ApplicationController
  include DetailsHelper
  skip_before_action :authenticate_user

  def new
    @detail = Detail.new
  end

  def create
    @detail = Detail.new(detail_params)
    @detail.uuid = SecureRandom.hex(10)
    if @detail.save
      render_success_response
    else
      render json: { errors: @detail.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def change_status
    @detail = Detail.find(params[:id])
    @detail.status = params[:status]
    if @detail.save
      update_users_notification
    else
      @message = 'An error has occurred'
    end
  end

  def update_user_ids
    @detail = Detail.find(params[:id])
    @project_id = params[:project_id]
    @users = User.mentioned_users(params[:username])
    new_users = @users - @detail.users
    add_new_users_to_detail(new_users)
    @detail_id = params[:id]
    @message = 'You have been Added to a Feature'
    @notification = create_new_notification
    broadcast_notification_to_new_users(new_users)
  end

  def feature_search
    initialize_chat
    if params[:search_items].present? && params[:search_items][:query].present?
      handle_search_items(params[:search_items])
    else
      handle_no_search_items
    end
  end

  private

  def detail_params
    params.require(:detail).permit(:title, :description, :project_id, :flagType, file: [])
  end
end
