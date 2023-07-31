# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DetailsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:detail) { create(:detail, project:) }

  describe 'PATCH #change_status' do
    context 'when the status is successfully changed' do
      it 'updates the status and sends notifications', :js do
        user = create(:user)
        session[:id] = user.id
        detail = create(:detail, status: 'Started')

        allow(controller).to receive(:current_user).and_return(user)
        params = {
          id: detail.id,
          status: 'Finished'
        }
        allow(ActionCable.server).to receive(:broadcast)
        allow(controller).to receive(:send_notification_email_to_user)

        patch(:change_status, params:, format: :js)

        expect(response).to have_http_status(:success)

        updated_detail = Detail.find(detail.id)
        expect(updated_detail.status).to eq('Finished')
      end
    end
  end
end
