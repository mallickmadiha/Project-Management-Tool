# frozen_string_literal: true

# app/controllers/search_controller.rb
class SearchController < ApplicationController
  skip_before_action :authenticate_user

  def search
    @detail_id = params[:id]
    detail = Detail.find(@detail_id)
    project = Project.find(detail.project_id)
    query = params[:query]
    results = project.users.where('username LIKE ?', "%#{query}%")

    render json: results
  end
end
