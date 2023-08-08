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
end
# rubocop:enable Metrics/BlockLength
