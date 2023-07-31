# frozen_string_literal: true

require 'rails_helper'

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
end
