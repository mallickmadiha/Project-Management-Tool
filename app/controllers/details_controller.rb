# frozen_string_literal: true

# app/controllers/details_controller.rb
class DetailsController < ApplicationController
  include DetailsHelper
  skip_before_action :authenticate_user
  def index
    @details = Detail.all
  end

  def show
    @detail = Detail.find(params[:id])
  end

  def new
    @detail = Detail.new
  end

  def elastic_search
    query = params.dig(:search_items, :query)
    project_id = params.dig(:search_items, :project_id)
    @project = Project.find(project_id)
    @details = Detail.search(Detail.search_items(query.strip)).records.where(project_id:)
    @search_items = 's'
    @chats = Chat.all
    @chat = Chat.new
  end

  def create
    @detail = create_detail

    if @detail.save
      render_success_response
    else
      render_error_response
    end
  end

  def edit
    @detail = Detail.find(params[:id])
  end

  def update
    @detail = Detail.update(detail_params)
    redirect_to detail_path(@detail)
  end

  def destroy
    @detail = Detail.find(params[:id])
    @detail.destroy
    redirect_to details_path
  end

  def change_status
    @detail = find_detail
    @detail.status = params[:status]

    if @detail.save
      update_users_notification
    else
      @message = 'An error has occurred'
    end
  end

  def update_user_ids
    @detail = find_detail
    @project_id = params[:project_id]
    @users = find_users_by_email

    new_users = @users - @detail.users
    add_new_users_to_detail(new_users)

    @detail_id = params[:id]
    @message = "You have been Added to Feature #{@detail_id}"
    @notification = create_new_notification

    broadcast_notification_to_new_users(new_users)
  end

  private

  def detail_params
    params.require(:detail).permit(:title, :description, :project_id, :flagType, file: [])
  end
end
