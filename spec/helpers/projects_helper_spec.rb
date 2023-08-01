# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do
  describe '#initialize_flags' do
    let!(:project) { create(:project) }
    let!(:detail1) { create(:detail, project:, flagType: 'backFlag') }
    let!(:detail2) { create(:detail, project:, flagType: 'currentIteration') }
    let!(:detail3) { create(:detail, project:, flagType: 'icebox') }

    it 'assigns backlogs, current, and icebox details to corresponding instance variables' do
      @details = project.details
      initialize_flags
    end
  end

  describe '#initialize_submit_flags' do
    it 'assigns submit flag characters to instance variables' do
      initialize_submit_flags
    end
  end
end
