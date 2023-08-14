# frozen_string_literal: true

# app/helpers/details_helper.rb
module DetailsHelper
  def initialize_chat
    @chats = Chat.all
    @chat = Chat.new
    @task = Task.new
  end

  def handle_search_items(search_items)
    query = search_items[:query].to_s.gsub(/[^\w\s]/, '').strip
    @project = Project.find_by(id: search_items[:project_id])
    options = {}
    options[:id] = query.to_i if query.to_i.positive?
    @details = filter_details(query, options)
    @search_items = query
  end

  def filter_details(query, options)
    search_items = Detail.search(Detail.search_items(query))
    if options[:id].present?
      search_items.records.where(id: options[:id])
    elsif @project
      search_items.records.where(project_id: @project.id)
    else
      search_items.records
    end
  end

  def handle_no_search_items
    @project = Project.find_by(id: params[:search_items][:project_id])
    @details = @project ? @project.details : []
    @search_items = ''
    initialize_chat
  end

  def render_success_response
    @status = @detail.status
    @users = @detail.users
    @tasks = @detail.tasks
    @id = @detail.id

    render json: { detail: @detail.uuid, id: @detail.id, status: @detail.status,
                   project_id: @detail.project_id, js_id: @id, tasks: @tasks,
                   users: @users, current_user: current_user.id }
  end

  def update_users_notification
    @detail_id = params[:id]
    @message = "Status of feature #{@detail.title} has been changed to #{@detail.status}"

    @notification = Notification.create(message: @message, user_id: current_user.id)
    @project.users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}", { message: @message, id: @notification.id })
      send_notification_email_to_user(user)
    end
  end

  def send_notification_email_to_user(user)
    UserMailer.notification_email_status(current_user.email, user.username,
                                         user.email, @detail.title, @detail.status, @detail.description).deliver_later
  end

  def add_new_users_to_detail(new_users)
    @detail.users << new_users
  end

  def create_new_notification
    Notification.create(message: @message, user_id: current_user.id)
  end

  def broadcast_notification_to_new_users(new_users)
    new_users.each do |user|
      ActionCable.server.broadcast("notifications_#{user.id}",
                                   {
                                     message: @message,
                                     id: @notification.id
                                   })
    end
  end

  def link_mentions(message)
    message.gsub(/@(\w+)/) do |mention|
      username = mention[1..]
      user = User.find_by(username:)
      if user
        link_to mention, user_path(user.username), class: 'text-dark pointer'
      else
        mention
      end
    end
  end
end
