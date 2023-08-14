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
    @detail.uuid = SecureRandom.uuid.gsub(/[^\w\s]/, '').strip
    if @detail.save
      render_success_response
    else
      render json: { errors: @detail.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def change_status
    @detail = Detail.find(params[:id])
    @detail.status = params[:status]
    @project = Project.find(@detail.project_id)
    if @detail.save
      update_users_notification
    else
      @message = 'An error has occurred'
    end
  end

  def update_user_ids
    @detail = Detail.find(params[:id])
    @users = User.mentioned_users(params[:username])

    if @users.length.positive?
      new_users = @users - @detail.users
      assign_new_users(new_users, @detail)
      create_and_broadcast_notification(new_users, @detail.title)
    else
      @message = 'Please add a user to assign to your feature'
    end
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

  def assign_new_users(new_users, detail)
    add_new_users_to_detail(new_users)
    @detail_id = detail.id
  end

  def create_and_broadcast_notification(users, title)
    @message = "User(s) have been added to the feature #{title}"
    @notification = create_new_notification
    broadcast_notification_to_new_users(users)
  end
end
