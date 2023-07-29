# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DetailsHelper, type: :helper do
  let(:current_user) { create(:user) }

  describe '#update_users_notification' do
    it 'creates a notification and broadcasts it to users' do
      detail = create(:detail)
      params[:id] = detail.id
      detail.status = 'Finished'
      assign(:detail, detail)

      allow(helper).to receive(:current_user).and_return(current_user)

      expect(helper).to receive(:create_notification).and_call_original
      expect(helper).to receive(:broadcast_notification_to_users).and_call_original

      helper.update_users_notification
    end
  end
end
