# frozen_string_literal: true

# app/controllers/details_users_controller.rb
class DetailsUsersController < ApplicationController
  def new; end

  def create
    details_user = DetailsUser.new(details_user_params)
    details_user.save
    redirect_to detail_path(detail_id)
  end

  def destroy
    details_user = DetailsUser.find(params[:id])
    details_user.destroy
    redirect_to detail_path(detail_id)
  end

  private

  def details_user_params
    params.require(:details_user).permit(:detail_id, :user_id)
  end
end
