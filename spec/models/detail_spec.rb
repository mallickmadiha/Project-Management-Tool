# frozen_string_literal: true

require 'rails_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Detail, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      association = described_class.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has and belongs to many users' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_and_belongs_to_many)
    end

    it 'has many chats with dependent destroy' do
      association = described_class.reflect_on_association(:chats)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many tasks with dependent destroy' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'enums' do
    it 'defines the correct enum values for status' do
      expect(described_class.statuses).to eq({ 'Started' => 0, 'Finished' => 1, 'Delivered' => 2 })
    end

    it 'defines the correct enum values for flagType' do
      expect(described_class.flagTypes).to eq({ 'backFlag' => 0, 'icebox' => 1, 'currentIteration' => 2 })
    end
  end

  describe 'validations' do
    context 'positive test cases' do
      it 'is valid with valid attributes' do
        detail = FactoryBot.build(:detail, title: 'Valid Detail', description: 'This is a valid detail.')

        expect(detail).to be_valid
        expect(detail.errors).to be_empty
      end

      it 'is valid with a title of maximum length' do
        long_title = 'a' * 30
        detail = FactoryBot.build(:detail, title: long_title, description: 'This is a valid detail.')

        expect(detail).to be_valid
        expect(detail.errors).to be_empty
      end
    end
    context 'negative test cases' do
      it 'is not valid without a title' do
        detail = FactoryBot.build(:detail, title: nil)

        expect(detail).not_to be_valid
        expect(detail.errors[:title]).to include("can't be blank")
      end

      it 'is not valid without a description' do
        detail = FactoryBot.build(:detail, description: nil)

        expect(detail).not_to be_valid
        expect(detail.errors[:description]).to include("Description can't be blank")
      end

      it 'is not valid if title exceeds 30 characters' do
        detail = FactoryBot.build(:detail, title: 'a' * 31)

        expect(detail).not_to be_valid
        expect(detail.errors[:title]).to include('must be between 5 and 30 characters')
      end
    end
  end

  describe '.search_items' do
    it 'returns a valid search definition without query' do
      result = Detail.search_items('')
      expected_result = {
        query: {
          bool: {
            must: []
          }
        }
      }
      expect(result).to eq(expected_result)
    end

    it 'returns a valid search definition with a query' do
      query = 'example_query'
      result = Detail.search_items(query)
      expected_result = {
        query: {
          bool: {
            must: [
              {
                query_string: {
                  query: "*#{query}*"
                }
              }
            ]
          }
        }
      }
      expect(result).to eq(expected_result)
    end
  end
end
# rubocop: enable Metrics/BlockLength
