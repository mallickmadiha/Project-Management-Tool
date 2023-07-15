# frozen_string_literal: true

require 'rails_helper'

# spec/models/project_spec.rb
RSpec.describe Project, type: :model do
  describe 'validations' do
    it 'is not valid without a name' do
      project = FactoryBot.build(:project, name: nil)

      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("Name can't be blank")
    end

    it 'is not valid if name exceeds 255 characters' do
      project = FactoryBot.build(:project, :with_long_name)

      expect(project).not_to be_valid
      expect(project.errors[:name]).to include('Name is too long (maximum is 255 characters)')
    end
  end
end
