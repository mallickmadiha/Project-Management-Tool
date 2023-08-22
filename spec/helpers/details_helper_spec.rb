# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe DetailsHelper, type: :helper do
  describe '#initialize_chat' do
    it 'initializes @chats and @chat correctly' do
      create_list(:chat, 2)
      helper.initialize_chat
      expect(helper.instance_variable_get(:@chats).count).to eq(2)
      expect(helper.instance_variable_get(:@chat)).to be_a_new(Chat)
    end
  end

  describe '#filter_details' do
    it 'returns an empty list when both @project and options[:id] are absent and no Chat records exist' do
      helper.instance_variable_set(:@project, nil)
      filtered_details = helper.filter_details('query', {})
      expect(filtered_details).to be_empty
    end
  end

  describe '#broadcast_notification_to_new_users' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:notification) { instance_double('Notification', id: 123) }

    before do
      allow(Notification).to receive(:create).and_return(notification)
    end
  end

  describe '#link_mentions' do
    let(:user) { create(:user, username: 'testuser') }

    it 'replaces mentions with links for existing users' do
      message = 'Hello, @testuser!'
      allow(User).to receive(:find_by).with(username: 'testuser').and_return(user)

      result = helper.link_mentions(message)

      expected_link = link_to('@testuser', user_path(user.username), class: 'text-dark pointer')
      expect(result).to include(expected_link)
    end

    it 'leaves mentions unchanged for non-existing users' do
      message = 'Hello, @nonexistent!'
      allow(User).to receive(:find_by).with(username: 'nonexistent').and_return(nil)

      result = helper.link_mentions(message)

      expect(result).to include('@nonexistent')
    end
  end

  describe '#handle_search_items' do
    let(:project) { create(:project) }

    context 'when valid search items are provided' do
      let(:search_items) { { query: 'search_query', project_id: project.id } }

      it 'assigns filtered details and search items' do
        helper.handle_search_items(search_items)
      end
    end

    context 'when search query is a valid ID' do
      let(:search_items) { { query: '123', project_id: project.id } }

      it 'assigns filtered details and search items' do
        helper.handle_search_items(search_items)
      end
    end

    context 'when search query is not a valid ID' do
      let(:search_items) { { query: 'invalid', project_id: project.id } }

      it 'assigns all details and search items' do
        helper.handle_search_items(search_items)
      end
    end
  end

  describe '#handle_no_search_items' do
    let(:project) { create(:project) }

    context 'when a project is found' do
      let(:search_items) { { project_id: project.id } }

      it 'assigns project details and initializes chat' do
        allow(params).to receive(:[]).with(:search_items).and_return(search_items)

        helper.handle_no_search_items
      end
    end
  end

  describe '#render_success_response' do
    it 'renders the correct JSON response' do
      completed_tasks_count = 5
      total_tasks_count = 10

      task = instance_double(Task, id: 123)

      expected_response = {
        message: 'Task created successfully',
        id: task.id,
        completedTasksCount: completed_tasks_count,
        totalTasksCount: total_tasks_count
      }

      allow(helper).to receive(:render)
      assign(:task, task)

      helper.render_success_response(completed_tasks_count, total_tasks_count)

      expect(helper).to have_received(:render).with(json: expected_response, status: :ok)
    end
  end
end
# rubocop:enable Metrics/BlockLength
