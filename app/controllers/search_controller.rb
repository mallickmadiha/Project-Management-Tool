# frozen_string_literal: true

# app/controllers/search_controller.rb
class SearchController < ApplicationController
  # skip_before_action :authenticate_user, only: %i[search]

  def search
    @detail_id = params[:id]
    detail = Detail.find(@detail_id)
    project = Project.find(detail.project_id)
    query = params[:query]
    # Perform your search logic and retrieve the results
    results = project.users.where('email LIKE ?', "%#{query}%") # Update with your search logic

    render json: results
  end
end
