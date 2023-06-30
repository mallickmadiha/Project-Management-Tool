# frozen_string_literal: true

# app/controllers/details_controller.rb
class DetailsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index show create]

  def index
    @details = Detail.all
  end

  def show
    @detail = Detail.find(params[:id])
  end

  def new
    @detail = Detail.new
  end

  def create
    @detail = Detail.new(detail_params)
    @detail.uuid = SecureRandom.hex(10)
    @detail.save
    render json: { uuid: @detail.uuid, id: @detail.id, status: @detail.status }
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

  private

  def detail_params
    params.require(:detail).permit(:title, :description, :project_id, :flagType, file: [])
  end
end
