# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    let(:user1) { create(:user, username: 'john_doe') }
    let(:user2) { create(:user, username: 'jane_doe') }
    let(:project) { create(:project) }
    let(:detail) { create(:detail, project:) }

    before do
      project.users << [user1, user2]
      allow(Detail).to receive(:find).and_return(detail)
      allow(Project).to receive(:find).and_return(project)
    end

    context 'when search query matches user(s)' do
      it 'returns matching user(s) in JSON format' do
        get :search, params: { id: detail.id, query: 'doe' }
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.size).to eq(2)

        usernames = json_response.map { |user| user['username'] }
        expect(usernames).to match_array(%w[john_doe jane_doe])
      end
    end

    context 'when search query does not match any user' do
      it 'returns an empty array in JSON format' do
        get :search, params: { id: detail.id, query: 'foo' }
        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response).to be_empty
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
