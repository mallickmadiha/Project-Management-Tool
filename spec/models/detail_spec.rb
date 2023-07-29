#rubocop:disable all

require 'rails_helper'

RSpec.describe Detail, type: :model do
  describe 'validations' do
    it 'is not valid without a title' do
      detail = FactoryBot.build(:detail, title: nil)

      expect(detail).not_to be_valid
      expect(detail.errors[:title]).to include("Title can't be blank")
    end

    it 'is not valid without a description' do
      detail = FactoryBot.build(:detail, description: nil)

      expect(detail).not_to be_valid
      expect(detail.errors[:description]).to include("Description can't be blank")
    end

    it 'is not valid if title exceeds 30 characters' do
      detail = FactoryBot.build(:detail, title: 'a' * 31)

      expect(detail).not_to be_valid
      expect(detail.errors[:title]).to include('Title is too long (maximum is 30 characters)')
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
