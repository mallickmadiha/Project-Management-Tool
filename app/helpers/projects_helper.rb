# frozen_string_literal: true

# app/helpers/projects_helper.rb
module ProjectsHelper
  def initialize_chats
    @chats = Chat.all
    @chat = Chat.new
  end

  def initialize_flags
    @backlogs = @details.backFlag
    @current = @details.currentIteration
    @icebox = @details.icebox
  end

  def initialize_submit_flags
    @icebox_item_submit = 'i'
    @backlog_item_submit = 'b'
    @current_item_submit = 'c'
    @search_items = 's'
  end

  def render_404_page
    render 'partials/_404'
  end

  def save_project_and_associate_user
    @username = current_user.username
    @project.users << current_user
    @project.save
  end
end
