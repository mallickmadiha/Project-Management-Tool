# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe '#search' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:detail) { create(:detail, project:) }
    let(:query) { 'search_query' }

    before do
      allow(Detail).to receive(:find).with(detail.id.to_s).and_return(detail)
      allow(Project).to receive(:find).with(detail.project_id.to_s).and_return(project)
      allow(User).to receive(:with_username_query).and_return([user])
    end

    it 'renders JSON response with search results' do
      allow(Project).to receive(:find).with(detail.project_id).and_return(project)

      get :search, params: { id: detail.id, query: }

      expect(response).to have_http_status(:success)
      expect(response.body).to eq([user].to_json)
    end
  end
end
