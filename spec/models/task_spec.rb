# frozen_string_literal: true

require 'rails_helper'

# spec/models/task_spec.rb
RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is not valid without a name' do
      task = FactoryBot.build(:task, name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:name]).to include("Name can't be blank")
    end
  end
end
