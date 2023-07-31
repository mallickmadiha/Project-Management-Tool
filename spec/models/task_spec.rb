# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Task, type: :model do
  describe 'associations' do
    it 'belongs to a detail' do
      association = described_class.reflect_on_association(:detail)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'enums' do
    it 'defines the correct enum values for status' do
      expect(described_class.statuses).to eq({ 'Added' => 0, 'Done' => 1 })
    end
  end

  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with valid attributes' do
        detail = FactoryBot.create(:detail)
        task = FactoryBot.build(:task, name: 'Valid Task', detail:)

        expect(task).to be_valid
        expect(task.errors).to be_empty
      end

      it 'is valid with a name of maximum length' do
        detail = FactoryBot.create(:detail)
        long_name = 'a' * 255
        task = FactoryBot.build(:task, name: long_name, detail:)

        expect(task).to be_valid
        expect(task.errors).to be_empty
      end
    end

    context 'negative test cases' do
      it 'is not valid without a detail' do
        task = FactoryBot.build(:task, detail: nil)

        expect(task).not_to be_valid
        expect(task.errors[:detail]).to include('must exist')
      end

      it 'is not valid without a name' do
        detail = FactoryBot.create(:detail)
        task = FactoryBot.build(:task, name: nil, detail:)

        expect(task).not_to be_valid
        expect(task.errors[:name]).to include("can't be blank")
      end

      it 'is not valid if name exceeds maximum length' do
        detail = FactoryBot.create(:detail)
        long_name = 'a' * 256
        task = FactoryBot.build(:task, name: long_name, detail:)

        expect(task).not_to be_valid
        expect(task.errors[:name]).to include('must be between 5 and 255 characters')
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
