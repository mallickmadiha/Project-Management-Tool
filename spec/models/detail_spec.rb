# frozen_string_literal: true

require 'rails_helper'

# spec/models/detail_spec.rb
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
end
